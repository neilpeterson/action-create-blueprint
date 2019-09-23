<#
.DESCRIPTION
   Creates or assigns an Azure BluePrint

.NOTES
   Intent: Sample to demonstrate Azure BluePrints with GitHub Actions
#>

$ErrorActionPreference = "Stop"

# Auth
$TenantId = $Env:AZURETENANTID
$ClientId = $Env:AZURECLIENTID
$ClientSecret = $Env:AZUREPASSWORD | ConvertTo-SecureString -AsPlainText -Force

# Location Details
$CreationScope = $Env:INPUT_SCOPE
$BlueprintManagementGroup = $Env:INPUT_AZUREMANAGEMENTGROUPNAME
$BlueprintSubscriptionID = $Env:INPUT_AZURESUBSCRIPTIONID

$BlueprintName = $Env:INPUT_BLUEPRINTNAME
$BlueprintPath = $Env:INPUT_BLUEPRINTPATH
$PublishBlueprint = $Env:INPUT_PUBLISHBLUEPRINT
$BlueprintVersion = $Env:INPUT_VERSION

# Install Azure PowerShell modules
if (Get-Module -ListAvailable -Name Az.Accounts) {
   Write-Output "Az.Accounts module is allready installed."
}
else {
   Find-Module Az.Accounts | Install-Module -Force
}

if (Get-Module -ListAvailable -Name Az.Blueprint) {
   Write-Output "Az.Blueprint module is allready installed."
}
else {
   Find-Module Az.Blueprint | Install-Module -RequiredVersion 0.2.5 -Force
}

# Set Blueprint Scope (Subscription / Management Group)
if ($CreationScope -eq 'Subscription') {
   $blueprintScope = "-SubscriptionId $BlueprintSubscriptionID"
} else {
   $blueprintScope = "-ManagementGroupId $BlueprintManagementGroup"
}

# Connect to Azure
$creds = New-Object System.Management.Automation.PSCredential ($ClientId, $ClientSecret)
Connect-AzAccount -ServicePrincipal -Tenant $TenantId -Credential $creds -WarningAction silentlyContinue

# Create Blueprint
write-output "Creating Blueprint"
Invoke-Expression "Import-AzBlueprintWithArtifact -Name $BlueprintName -InputPath $BlueprintPath $blueprintScope -Force"

# Publish blueprint if publish
write-output "Publishing Blueprint"
if ($PublishBlueprint -eq "true") {
   $blueprintObject = Invoke-Expression "Get-AzBlueprint -Name $BlueprintName $blueprintScope"

   # Set version if increment
   if ($BlueprintVersion -eq "Increment") {
      if ($blueprintObject.versions[$blueprintObject.versions.count - 1] -eq 0) {
         $BlueprintVersion = 1
      } else {
         $BlueprintVersion = ([int]$blueprintObject.versions[$blueprintObject.versions.count - 1]) + 1
      }
   }
   # Publish blueprint
   Publish-AzBlueprint -Blueprint $BluePrintObject -Version $BlueprintVersion
}