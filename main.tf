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
  address_space       = [10.0.0.0/16]
  location            = var.location
  name                = "${var.project_name}-network"
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_machine" "vm" {
  location              = var.location
  name                  = "minecraft-server-machine"
  network_interface_ids = [azurerm_virtual_network.net.id]
  resource_group_name   = var.resource_group_name
  vm_size               = "Standard_DS1_v2"
  storage_os_disk {
    create_option = ""
    name          = ""
  }
}


