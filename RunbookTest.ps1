$webapp_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_standard_webapp.json"
$linked_templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_linked_template.json"

$webapp_templateObject = Invoke-WebRequest -uri $webapp_templateUrl| ConvertFrom-Json
$linked_templateObject = Invoke-WebRequest -uri $linked_templateUrl| ConvertFrom-Json

$linked_templateObject.properties.templateLink.uri = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_applicationinsight_template.json"
$linked_parameters = @{name="TestAppinsightWood"; location="Central US"}
$linked_templateObject.properties.parameters = $linked_parameters

$webapp_templateObject.resources.Add($linked_templateObject)

Write-Output $templateObject