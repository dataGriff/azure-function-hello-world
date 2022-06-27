param appServicePlanName string
@allowed([
  'B1'
  'B2'
  'B3' 
  'D1' 
  'F1' 
  'FREE' 
  'I1' 
  'I1v2' 
  'I2' 
  'I2v2'
  'I3'
  'I3v2'
  'P1V2'
  'P1V3'
  'P2V2'
  'P2V3'
  'P3V2'
  'P3V3'
  'PC2'
  'PC3'
  'PC4'
  'S1'
  'S2'
  'S3'
  'SHARED'
  'Y1'
])
param skuName string = 'Y1'

@allowed([
  'Shared'
  'Free'
  'Basic'
  'Standard'
  'Premium'
  'PremiumV2'
  'Isolated'
  'Dynamic'
])
param skuTier string = 'Dynamic'

param location string =  'northeurope'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName 
    tier: skuTier
  }
}

output id string = appServicePlan.id
