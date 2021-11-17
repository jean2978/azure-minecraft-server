# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "net" {
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  name                = "${var.project_name}-network"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "sub" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  location            = var.location
  name                = "${var.project_name}-interface"
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.sub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  location                         = var.location
  name                             = "minecraft-server-machine"
  network_interface_ids            = [azurerm_network_interface.nic.id]
  resource_group_name              = var.resource_group_name
  vm_size                          = "Standard_DS1_v2"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    name              = "${var.project_name}-osdisk"
    os_type           = "linux"
  }
  os_profile {
    admin_username = "adminuser"
    admin_password = "P@$$w0rd1234!"
    computer_name  = var.project_name
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "test"
  }
}


