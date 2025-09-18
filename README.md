# Terraform Experiments

This repository contains my **Terraform experiments** while learning **Cloud Computing** and integrating with **Microsoft Azure**.

## Getting Started

### Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)

### Setup Instructions

1. **Log in to Azure**

   ```bash
   az login
   # Or, if you prefer using a device code:
   az login --use-device-code
   ```

2. **Clone this repository**

   ```bash
   git clone https://github.com/nielxfb/terraform-experiments
   ```

3. **Navigate into a specific experiment**

   ```bash
   cd <directory_name>
   ```

4. **Initialize and apply Terraform**

   ```bash
   terraform init
   terraform apply
   ```

## Notes

* Each directory represents a separate experiment or use case.
* Make sure to review the Terraform configuration files before applying changes to avoid unexpected costs or resource creation.
