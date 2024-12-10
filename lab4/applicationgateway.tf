resource "azurerm_application_gateway" "appgtw" {
  name                = "myAppGateway"
  resource_group_name = "RG4"
  location            = "westeurope"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
}

output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.pubip.ip_address
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