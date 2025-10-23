resource "azurerm_resource_group" "nielxfb" {
  name     = "nielxfb-rg"
  location = "Southeast Asia"
}

resource "azurerm_kubernetes_cluster" "nielxfb" {
  name                = "nielxfb-aks"
  location            = azurerm_resource_group.nielxfb.location
  resource_group_name = azurerm_resource_group.nielxfb.name
  dns_prefix          = "nielxfbaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.nielxfb.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.nielxfb.kube_config_raw

  sensitive = true
}