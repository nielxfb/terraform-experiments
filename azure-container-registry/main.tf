resource "azurerm_resource_group" "nielxfb" {
  name     = "acr-nielxfb-rg"
  location = "Indonesia Central"
}

resource "azurerm_container_registry" "nielxfb" {
  name                = "acrnielxfb"
  resource_group_name = azurerm_resource_group.nielxfb.name
  location            = azurerm_resource_group.nielxfb.location
  sku                 = "Standard"

  admin_enabled          = false
  anonymous_pull_enabled = true
}
