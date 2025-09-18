# Azure Create VM

This Terraform configuration provisions a **Linux Virtual Machine (Ubuntu 24.04 LTS)** on **Microsoft Azure**, along with all the required networking resources.

## Resources Created

* **Resource Group** (`nielxfb-rg`)
* **Network Security Group (NSG)** with SSH access rule
* **Virtual Network (VNet)** and **Subnet**
* **Subnet & NSG Association**
* **Public IP Address**
* **Network Interface (NIC)**
* **Linux Virtual Machine** (Ubuntu 24.04 LTS, `Standard_D2s_v3`)

## Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* An active [Azure subscription](https://azure.microsoft.com/free/)
* SSH key pair available on your local machine

## How to Use

1. **Login to Azure**

   ```bash
   az login
   ```

2. **Prepare variables**
   Copy the example `terraform.tfvars.example` into a working `terraform.tfvars` file:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

   Then edit `terraform.tfvars` with your preferred values (e.g., username, SSH key path, SSH port).

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

6. **Connect to the VM**

   ```bash
   ssh <your_admin_username>@<public_ip>
   ```

## Variables

| Variable              | Description                 | Example             |
| --------------------- | --------------------------- | ------------------- |
| `username`            | Admin username for the VM   | `azureuser`         |
| `ssh_public_key_path` | Path to your SSH public key | `~/.ssh/id_rsa.pub` |
| `ssh_port`            | SSH port (default: 22)      | `22`                |

## Notes

* The NSG only allows inbound traffic on the specified `ssh_port`.
* VM size is set to `Standard_D2s_v3` but can be changed if needed.
* Remember to destroy resources when no longer needed to avoid costs:

  ```bash
  terraform destroy
  ```
  