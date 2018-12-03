$templateUrl = "https://raw.githubusercontent.com/lesintion/AzureARMtemplate/master/arm_webapp_template.json";
$templateObject = Invoke-WebRequest -uri $templateUrl| ConvertFrom-Json
Write-Output $templateObject