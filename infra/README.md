# Infrastructure Deployment

This directory contains the Bicep Infrastructure as Code (IaC) files to deploy the application infrastructure based on the configuration defined in `app.yaml`.

## Files

- `main.bicep` - Main Bicep template that defines all the infrastructure resources
- `main.parameters.json` - Parameter file with default values for deployment
- `app.yaml` - Original infrastructure specification (reference)

## Resources Deployed

The Bicep template creates the following Azure resources:

1. **Storage Account** (`mystorageacctmx01`)
   - Type: StorageV2
   - SKU: Standard_LRS (configurable)
   - Security: HTTPS only, TLS 1.2 minimum, private blob access

2. **App Service Plan** (`myappserviceplanmx01`)
   - SKU: F1 (Free tier, configurable)
   - Platform: Windows
   - Scaling: Basic single instance

3. **Web App** (`mywebappmx01`)
   - Platform: Windows
   - Python: 3.11
   - HTTPS Only: Enabled
   - Deployment: Package-based

## Prerequisites

- Azure CLI installed and logged in
- Azure subscription with appropriate permissions
- Resource Group: `rg-mcp-test` (will be referenced)

## Deployment Instructions

### Option 1: Using Azure CLI

```bash
# Deploy to existing resource group
az deployment group create \
  --resource-group rg-mcp-test \
  --template-file main.bicep \
  --parameters main.parameters.json

# Or deploy with custom parameters
az deployment group create \
  --resource-group rg-mcp-test \
  --template-file main.bicep \
  --parameters location=eastus baseName=mx01 storageAccountSku=Standard_LRS appServicePlanSku=B1
```

### Option 2: Using Azure PowerShell

```powershell
# Deploy to existing resource group
New-AzResourceGroupDeployment -ResourceGroupName "rg-mcp-test" -TemplateFile "main.bicep" -TemplateParameterFile "main.parameters.json"
```

### Option 3: Using Azure Portal

1. Navigate to Azure Portal
2. Go to Resource Groups → rg-mcp-test
3. Click "Deploy a custom template"
4. Upload `main.bicep` file
5. Fill in parameters or upload `main.parameters.json`
6. Review and deploy

## Parameters

| Parameter | Description | Default | Allowed Values |
|-----------|-------------|---------|----------------|
| `location` | Azure region for resources | `eastus` | Any valid Azure region |
| `baseName` | Base name suffix for resources | `mx01` | String (alphanumeric) |
| `storageAccountSku` | Storage account performance tier | `Standard_LRS` | Standard_LRS, Standard_GRS, Standard_ZRS, Premium_LRS |
| `appServicePlanSku` | App Service plan pricing tier | `F1` | F1, B1, B2, B3, S1, S2, S3, P1, P2, P3 |

## Outputs

After successful deployment, the template provides the following outputs:

- `resourceGroupName` - Name of the resource group
- `storageAccountName` - Name of the created storage account
- `storageAccountPrimaryKey` - Primary access key for the storage account
- `appServicePlanName` - Name of the App Service plan
- `webAppName` - Name of the web application
- `webAppUrl` - HTTPS URL of the deployed web application
- `webAppDefaultUrl` - Default hostname of the web application

## Post-Deployment

After deployment, you can:

1. Deploy your FastAPI application to the Web App using:
   - Azure DevOps Pipelines
   - GitHub Actions
   - Visual Studio Code
   - Azure CLI

2. Configure application settings in the Web App if needed

3. Set up custom domains and SSL certificates if required

## Customization

To modify the infrastructure:

1. Edit `main.bicep` to add/remove resources or change configurations
2. Update `main.parameters.json` with your preferred values
3. Redeploy using the same Azure CLI commands

## Application Deployment

This template creates the infrastructure. To deploy the Python FastAPI application (`src/main.py`):

```bash
# Zip your application code
zip -r app.zip src/

# Deploy using Azure CLI
az webapp deployment source config-zip \
  --resource-group rg-mcp-test \
  --name mywebappmx01 \
  --src app.zip
```

The application will be available at the URL provided in the `webAppUrl` output.