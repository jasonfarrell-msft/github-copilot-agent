// Bicep template for application infrastructure based on infra/app.yaml
// Generated from app.yaml configuration

@description('Location for all resources')
param location string = 'eastus'

@description('Base name for resources')
param baseName string = 'mx01'

@description('Storage Account SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageAccountSku string = 'Standard_LRS'

@description('App Service Plan SKU')
@allowed([
  'F1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
])
param appServicePlanSku string = 'F1'

// Variables for resource names
var resourceGroupName = 'rg-mcp-test'
var storageAccountName = 'mystorageacct${baseName}'
var appServicePlanName = 'myappserviceplan${baseName}'
var webAppName = 'mywebapp${baseName}'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSku
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanSku == 'F1' ? 'Free' : (contains(['B1', 'B2', 'B3'], appServicePlanSku) ? 'Basic' : (contains(['S1', 'S2', 'S3'], appServicePlanSku) ? 'Standard' : 'Premium'))
    capacity: 1
  }
  kind: 'app'
  properties: {
    reserved: false // false for Windows, true for Linux
    perSiteScaling: false
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    reserved: false // false for Windows, true for Linux
    siteConfig: {
      alwaysOn: appServicePlanSku != 'F1' // Always On not available in Free tier
      httpLoggingEnabled: true
      detailedErrorLoggingEnabled: true
      requestTracingEnabled: true
      appSettings: [
        {
          name: 'WEBSITE_PYTHON_DEFAULT_VERSION'
          value: '3.11'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      linuxFxVersion: '' // Empty for Windows
      connectionStrings: []
    }
    clientAffinityEnabled: false
    publicNetworkAccess: 'Enabled'
  }
}

// Outputs
@description('Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Storage Account Name')
output storageAccountName string = storageAccount.name

@description('Storage Account Primary Key')
output storageAccountPrimaryKey string = storageAccount.listKeys().keys[0].value

@description('App Service Plan Name')
output appServicePlanName string = appServicePlan.name

@description('Web App Name')
output webAppName string = webApp.name

@description('Web App Default Host Name')
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'

@description('Web App Deployment Slot URL')
output webAppDefaultUrl string = webApp.properties.defaultHostName