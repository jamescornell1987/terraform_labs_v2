resource "azurerm_application_gateway" "appgtw" {
  name                = "myAppGateway"
  resource_group_name = var.resourcegroup
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = "qalabFrontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "qalabAGIPConfig"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }

  backend_address_pool {
    name = "qalabBackendPool"
  }

  backend_http_settings {
    name                  = "qalabHTTPsetting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "qalabListener"
    frontend_ip_configuration_name = "qalabAGIPConfig"
    frontend_port_name             = "qalabFrontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "qalabRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "qalabListener"
    backend_address_pool_name  = "qalabBackendPool"
    backend_http_settings_name = "qalabHTTPsetting"
    priority                   = 10
  }
}
output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.pubip.ip_address
}