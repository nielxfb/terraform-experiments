resource "azurerm_resource_group" "nielxfb" {
  name     = "nielxfb-rg"
  location = "Indonesia Central"
}

resource "azurerm_network_security_group" "nielxfb" {
  name                = "nielxfb-nsg"
  location            = azurerm_resource_group.nielxfb.location
  resource_group_name = azurerm_resource_group.nielxfb.name

  security_rule {
    name                       = "allow-ssh-traffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.ssh_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "nielxfb" {
  name                = "nielxfb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.nielxfb.location
  resource_group_name = azurerm_resource_group.nielxfb.name
}

resource "azurerm_subnet" "nielxfb" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.nielxfb.name
  virtual_network_name = azurerm_virtual_network.nielxfb.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nielxfb" {
  subnet_id                 = azurerm_subnet.nielxfb.id
  network_security_group_id = azurerm_network_security_group.nielxfb.id
}

resource "azurerm_network_interface" "nielxfb" {
  name                = "nielxfb-nic"
  location            = azurerm_resource_group.nielxfb.location
  resource_group_name = azurerm_resource_group.nielxfb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.nielxfb.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.nielxfb.id
  }
}

resource "azurerm_public_ip" "nielxfb" {
  name                = "nielxfb-pip"
  resource_group_name = azurerm_resource_group.nielxfb.name
  location            = azurerm_resource_group.nielxfb.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_linux_virtual_machine" "nielxfb" {
  name                = "nielxfb-machine"
  resource_group_name = azurerm_resource_group.nielxfb.name
  location            = azurerm_resource_group.nielxfb.location
  size                = "Standard_D2s_v3"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.nielxfb.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}