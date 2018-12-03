$webapp_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_standard_webapp.json"
$linked_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_linked_template.json"
$webapp_deployment_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_webapp_deployment_template.json"

# $webapp_templateObject = Invoke-WebRequest -uri $webapp_templateUrl| ConvertFrom-Json
# $linked_templateObject = Invoke-WebRequest -uri $linked_templateUrl| ConvertFrom-Json

# $linked_templateObject.properties.templateLink.uri = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_applicationinsight_template.json"
# $linked_parameters = @{
#     name     = "TestAppinsightWood"
#     location = "Central US"
# }
# $linked_templateObject.properties.parameters = $linked_parameters



$webapp_templateObject.resources += $linked_templateObject

$webapp_parameters = @{
    name                      = "automationtestwlazure11"
    hostingPlanName           = "ServicePlanautomationTest_bbbb"
    hostingEnvironment        = ""
    location                  = "Central US"
    sku                       = "Standard"
    skuCode                   = "S1"
    workerSize                = "0"
    serverFarmResourceGroup   = "k8s"
    subscriptionId            = "0d067ba0-399d-435e-98bd-a33ba0d5fbcd"
    siteConfig                = @{}
    # includeApplicationInsight = $true
}

# $webapp_template = Invoke-WebRequest -uri $webapp_deployment_templateUrl| ConvertFrom-Json
# $webapp_template.properties.template = $webapp_templateObject
# $webapp_template.properties.parameters = $webapp_parameters
$resourceGroupName = "k8s"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -NameFromTemplate $webapp_parameters.name -TemplateUri $webapp_templateUrl -TemplateParameterObject $webapp_parameters;

Write-Output $templateObject 