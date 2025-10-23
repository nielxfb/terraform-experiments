# Azure Kubernetes Service (AKS) Cluster

This Terraform configuration provisions an **Azure Kubernetes Service (AKS) cluster** on **Microsoft Azure**, along with the required resource group and networking components.

## Resources Created

* **Resource Group** (`nielxfb-rg`)
* **Azure Kubernetes Service (AKS) Cluster** (`nielxfb-aks`)
  * DNS Prefix: `nielxfbaks`
  * Node Pool: 1 node with `Standard_A2_v2` VM size
  * Identity: System-assigned managed identity
  * Environment Tag: Production

## Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) (Kubernetes command-line tool)
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

6. **Configure kubectl**

   After the cluster is created, configure kubectl to connect to your AKS cluster:

   ```bash
   az aks get-credentials --resource-group nielxfb-rg --name nielxfb-aks
   ```

7. **Verify the cluster**

   ```bash
   kubectl get nodes
   kubectl cluster-info
   ```

## Variables

| Variable          | Description                           | Example                                |
| ----------------- | ------------------------------------- | -------------------------------------- |
| `subscription_id` | The Subscription ID for Azure account | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |

## Working with the Cluster

### Deploy a sample application

```bash
# Deploy nginx
kubectl create deployment nginx --image=nginx

# Expose the deployment
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Check the service
kubectl get services
```

### Scale the node pool

To scale the number of nodes:

```bash
az aks scale --resource-group nielxfb-rg --name nielxfb-aks --node-count 3
```

Or update the `node_count` in `main.tf` and run `terraform apply`.

### Access Kubernetes Dashboard

```bash
az aks browse --resource-group nielxfb-rg --name nielxfb-aks
```

### View cluster credentials

The Terraform outputs include sensitive cluster credentials. To view them:

```bash
# View kubeconfig
terraform output -raw kube_config

# View client certificate
terraform output -raw client_certificate
```

## Notes

* The cluster is deployed in the **Southeast Asia** region.
* Default node pool uses **Standard_A2_v2** VMs (2 vCPUs, 4 GB RAM) - suitable for development/testing.
* The cluster uses a **System-assigned managed identity** for Azure resource authentication.
* **1 node** is provisioned by default in the default node pool.
* Kubernetes version is automatically selected by Azure (latest stable version).
* Remember to destroy resources when no longer needed to avoid costs:

  ```bash
  terraform destroy
  ```

  ⚠️ **Warning**: This will delete the entire cluster and all workloads running on it.

## Additional Configuration

If you need to modify the cluster settings:

* **Change node count**: Update `node_count` in the `default_node_pool` block in `main.tf`
* **Change VM size**: Modify `vm_size` in the `default_node_pool` block (e.g., `Standard_D2s_v3`, `Standard_B2s`)
* **Change region**: Update the `location` in the resource group definition
* **Add more node pools**: Add additional `azurerm_kubernetes_cluster_node_pool` resources
* **Specify Kubernetes version**: Add `kubernetes_version = "1.28.0"` to the cluster resource
* **Enable monitoring**: Add an `oms_agent` block to enable Azure Monitor for containers
* **Configure network**: Add `network_profile` block for custom networking settings

## Cost Optimization

* The **Standard_A2_v2** VM size is economical but limited. Consider using **Standard_B2s** for better performance at a similar price.
* Use **spot instances** for non-production workloads to save costs.
* Enable **cluster autoscaling** to automatically adjust node count based on demand.
* Stop the cluster when not in use (note: AKS still charges for the underlying VMs).

## Troubleshooting

### Unable to connect to cluster

```bash
# Refresh credentials
az aks get-credentials --resource-group nielxfb-rg --name nielxfb-aks --overwrite-existing
```

### Check cluster status

```bash
az aks show --resource-group nielxfb-rg --name nielxfb-aks --query "powerState"
```

### View cluster logs

```bash
az aks show --resource-group nielxfb-rg --name nielxfb-aks
```
