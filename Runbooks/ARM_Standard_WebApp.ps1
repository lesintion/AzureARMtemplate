param(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)

<#
.SYNOPSIS
    Registers RPs
#>

function ConvertTo-Hashtable {
    [CmdletBinding()]
    [OutputType('hashtable')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
 
    process {
        ## Return null if the input is null. This can happen when calling the function
        ## recursively and a property is null
        if ($null -eq $InputObject) {
            return $null
        }
 
        ## Check if the input is an array or collection. If so, we also need to convert
        ## those types into hash tables as well. This function will convert all child
        ## objects into hash tables (if applicable)
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable -InputObject $object
                }
            )
 
            ## Return the array but don't enumerate it because the object may be pretty complex
            Write-Output -NoEnumerate $collection
        } elseif ($InputObject -is [psobject]) { ## If the object has properties that need enumeration
            ## Convert it to its own hash table and return it
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            $hash
        } else {
            ## If the object isn't an array, collection, or other object, it's already a hash table
            ## So just return it.
            $InputObject
        }
    }
}
function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Output "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

function ProcessWebApp {

    Param(
        [string]$resourceGroupName,
        [string]$templateFilePath,
        [object]$parameterObject
    )
    
    #******************************************************************************
    # Script body
    # Execution begins here
    #******************************************************************************
    $ErrorActionPreference = "Stop"

    # Connect to Azure account   
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    Connect-AzureRmAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

    # Register RPs
    $resourceProviders = @("microsoft.web", "microsoft.insights");
    if ($resourceProviders.length) {
        Write-Host "Registering resource providers"
        foreach ($resourceProvider in $resourceProviders) {
            RegisterRP($resourceProvider);
        }
    }

    #Create or check for existing resource group
    $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
    if (!$resourceGroup) {
        Write-Output "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
        $resourceGroupLocation = $parameterObject.location;
        Write-Output "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
        New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    }
    else {
        Write-Output "Using existing resource group '$resourceGroupName'";
    }

    # Start the deployment
    Write-Output "Starting deployment...";

    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -NameFromTemplate $parameterObject.name -TemplateUri $templateFilePath -TemplateParameterObject $parameterObject;

}



if ($WebhookData) {
    #$WebhookData = $WebhookData | ConvertFrom-Json
    try {
        $json = $WebhookData.RequestBody | ConvertFrom-Json
        $resourceGroupName = $json.resourceGroupName;
        $templateFilePath = $json.templateFilePath;

        # $parameterObject = @{
        #     name                    = $json.parameters.name
        #     hostingPlanName         = $json.parameters.hostingPlanName
        #     hostingEnvironment      = $json.parameters.hostingEnvironment
        #     location                = $json.parameters.location
        #     sku                     = $json.parameters.sku
        #     skuCode                 = $json.parameters.skuCode
        #     workerSize              = $json.parameters.workerSize
        #     serverFarmResourceGroup = $json.parameters.serverFarmResourceGroup
        #     subscriptionId          = $json.parameters.subscriptionId
        # };

        $parameterObject = ConvertTo-Hashtable $json.parameters
        ProcessWebApp $resourceGroupName $templateFilePath $parameterObject
        # }
    }
    catch {
        Write-Output "Error occured: $_";
    }
    
}
else {
    Write-Output "Parameters to process the web app is not available";
}