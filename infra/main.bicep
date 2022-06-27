targetScope='subscription'

param service string = 'helloworld'
param environment string = 'dv'
param location string = 'northeurope'

var resourceGroupName = '${environment}-${service}-rg'
var storageAccountName  = '${environment}${service}steundgrf'
var applicationInsightsName  = '${environment}-${service}-ai-eun-dgrf'
var appServicePlanName  = '${environment}-${service}-st-eun-dgrf'
var functionAppName  = '${environment}-${service}-azfn-eun-dgrf'

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
}

module storageAccount 'modules/storageAccount.bicep' = {
  name: storageAccountName
  scope: newRG
   params: {
     name: storageAccountName
     kind: 'StorageV2'
     skuName: 'Standard_LRS'
     location: location
   }
}

module applicationInsights 'modules/applicationInsights.bicep' = {
  name: applicationInsightsName 
  scope: newRG
  params: {
    appInsightsName: applicationInsightsName
    Application_Type: 'web'
    kind: 'web'
    location: location
  }
  dependsOn: [
    storageAccount
  ]
}

module appServicePlan 'modules/appServicePlan.bicep' = {
  name: appServicePlanName
  scope: newRG
  params: {
    appServicePlanName: appServicePlanName
    skuName: 'Y1'
    skuTier: 'Dynamic'
    location: location
  }
  dependsOn: [
    applicationInsights
  ]
}

module functionApp 'modules/functionApp.bicep' = {
  name: functionAppName
  scope: newRG
  params: {
    applicationInsightsKey: applicationInsights.outputs.instrumentKey
    functionAppName: functionAppName
    appServerPlanId: appServicePlan.outputs.id
    storageAccountName: storageAccountName
    location: location
  }
  dependsOn: [
    storageAccount
    applicationInsights
    appServicePlan
  ]
}
