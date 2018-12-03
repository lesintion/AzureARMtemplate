$webapp_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_standard_webapp.json"
$linked_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_linked_template.json"
$webapp_deployment_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_webapp_deployment_template.json"

Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Output "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

$webapp_parameters = @{
    name                      = "automationtestwlazure11"
    hostingPlanName           = "ServicePlanautomationTest_bbbb"
    hostingEnvironment        = ""
    location                  = "East US"
    sku                       = "Standard"
    skuCode                   = "S1"
    workerSize                = "0"
    serverFarmResourceGroup   = "k8s"
    subscriptionId            = "0d067ba0-399d-435e-98bd-a33ba0d5fbcd"
    siteConfig                = @{}
    includeApplicationInsight = $false
}

# $webapp_template = Invoke-WebRequest -uri $webapp_deployment_templateUrl| ConvertFrom-Json
# $webapp_template.properties.template = $webapp_templateObject
# $webapp_template.properties.parameters = $webapp_parameters
$resourceGroupName = "k8s"

if ($webapp_parameters.includeApplicationInsight) {
    RegisterRP "microsoft.insights"
}

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -NameFromTemplate $webapp_parameters.name -TemplateUri $webapp_templateUrl -TemplateParameterObject $webapp_parameters;

Write-Output $templateObject 