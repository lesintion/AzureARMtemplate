$webapp_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_standard_webapp.json"
$applicationInsight_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_applicationinsight_template.json"
$linked_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_linked_template.json"
$webapp_deployment_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_webapp_deployment_template.json"

Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Output "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}
function TestWebApp {
    param (
        $resourceGroupName = "k8s",
        $templateUrl = $webapp_templateUrl 
    )
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
    
    if ($webapp_parameters.includeApplicationInsight) {
        RegisterRP "microsoft.insights"
    }
    
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -NameFromTemplate $webapp_parameters.name -TemplateUri $templateUrl -TemplateParameterObject $webapp_parameters
}

function TestApplicationInsight {
    param (
        $resourceGroupName = "k8s",
        $templateUrl = $applicationInsight_templateUrl 
    )

    $appInsight_parameters = @{
        name="woodtest111"
    }

    $key = New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -NameFromTemplate $appInsight_parameters.name -TemplateUri $templateUrl -TemplateParameterObject $appInsight_parameters

    Write-Output $key 
    
}

TestApplicationInsight

