resource "azurerm_resource_group" "resgrp" {
  name     = var.resourcegroup
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  resource_group_name = var.resourcegroup
  location            = var.location
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "myAGSubnet"
  resource_group_name  = var.resourcegroup
  virtual_network_name = "myVNet"
  address_prefixes     = ["10.21.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "myBackendSubnet"
  resource_group_name  = var.resourcegroup
  virtual_network_name = "myVNet"
  address_prefixes     = ["10.21.1.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  name                = "myAGPublicIPAddress"
  resource_group_name = var.resourcegroup
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic-1"
  location            = var.location
  resource_group_name = var.resourcegroup

  ip_configuration {
    name                          = "nic-ipconfig-1"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "nic-2"
  location            = var.location
  resource_group_name = var.resourcegroup

  ip_configuration {
    name                          = "nic-ipconfig-2"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assc1" {
  network_interface_id    = azurerm_network_interface.nic1.id
  ip_configuration_name   = "nic-ipconfig-1"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgtw.backend_address_pool).0.id
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assc2" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = "nic-ipconfig-2"
  backend_address_pool_id = tolist(azurerm_application_gateway.appgtw.backend_address_pool).0.id
}