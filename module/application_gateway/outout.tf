output "id" {
  value = azurerm_application_gateway.this.id
}

output "name" {
  value = azurerm_application_gateway.this.name
}

output "frontend_ip_configuration_name" {
  value = var.frontend_ip_configuration_name
}

output "backend_address_pool_name" {
  value = var.backend_address_pool_name
}
