# Azure Container Registry

This Terraform configuration provisions an **Azure Container Registry (ACR)** on **Microsoft Azure**, along with the required resource group.

## Resources Created

* **Resource Group** (`acr-nielxfb-rg`)
* **Azure Container Registry** (`acrnielxfb`)
  * SKU: Standard
  * Admin access: Disabled
  * Anonymous pull: Enabled

## Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* An active [Azure subscription](https://azure.microsoft.com/free/)

## How to Use

1. **Login to Azure**

   ```bash
   az login
   ```

2. **Prepare variables**
   Create a `terraform.tfvars` file:

   ```bash
   cat > terraform.tfvars <<EOF
   subscription_id = "your-azure-subscription-id"
   EOF
   ```

   Replace `your-azure-subscription-id` with your actual Azure subscription ID. You can find it by running:

   ```bash
   az account show --query id -o tsv
   ```

3. **Initialize Terraform**

   ```bash
   terraform init
   ```

4. **Review the plan**

   ```bash
   terraform plan
   ```

5. **Apply the configuration**

   ```bash
   terraform apply
   ```

6. **Verify the registry**

   ```bash
   az acr list --resource-group acr-nielxfb-rg --output table
   ```

## Variables

| Variable          | Description                           | Example                                |
| ----------------- | ------------------------------------- | -------------------------------------- |
| `subscription_id` | The Subscription ID for Azure account | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |

## Using the Container Registry

### Login to the registry

Since admin access is disabled, you'll need to authenticate using Azure AD:

```bash
az acr login --name acrnielxfb
```

### Tag and push an image

```bash
# Tag your image
docker tag my-image:latest acrnielxfb.azurecr.io/my-image:latest

# Push to ACR
docker push acrnielxfb.azurecr.io/my-image:latest
```

### Pull an image

Since anonymous pull is enabled, you can pull images without authentication:

```bash
docker pull acrnielxfb.azurecr.io/my-image:latest
```

## Notes

* The registry is configured with the **Standard SKU** which provides 100 GB of storage.
* **Admin access is disabled** for security best practices. Use Azure AD authentication instead.
* **Anonymous pull is enabled**, allowing public access to pull images without authentication.
* The registry is deployed in the **Indonesia Central** region.
* Remember to destroy resources when no longer needed to avoid costs:

  ```bash
  terraform destroy
  ```

## Additional Configuration

If you need to modify the registry settings:

* **Change SKU**: Modify the `sku` parameter in `main.tf` (options: Basic, Standard, Premium)
* **Enable admin access**: Set `admin_enabled = true` in `main.tf`
* **Disable anonymous pull**: Set `anonymous_pull_enabled = false` in `main.tf`
* **Change location**: Update the `location` in the resource group definition

