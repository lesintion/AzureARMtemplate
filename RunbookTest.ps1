$webapp_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_standard_webapp.json"
$linked_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_linked_template.json"

$webapp_templateObject = Invoke-WebRequest -uri $webapp_templateUrl| ConvertFrom-Json
$linked_templateObject = Invoke-WebRequest -uri $linked_templateUrl| ConvertFrom-Json

$linked_templateObject.properties.templateLink.uri = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_applicationinsight_template.json"
$linked_parameters = @{
    name     = "TestAppinsightWood"
    location = "Central US"
}
$linked_templateObject.properties.parameters = $linked_parameters



$webapp_templateObject.resources += $linked_templateObject

$webapp_parameters = @{
    name                    = "automationtestwlazure11"
    hostingPlanName         = "ServicePlanautomationTest_bbbb"
    hostingEnvironment      = ""
    location                = "Central US"
    sku                     = "Standard"
    skuCode                 = "S1"
    workerSize              = "0"
    serverFarmResourceGroup = "eatai"
    subscriptionId          = "0d067ba0-399d-435e-98bd-a33ba0d5fbcd"
}


Write-Output $templateObject