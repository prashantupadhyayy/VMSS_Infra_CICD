variable "app_gw_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "capacity" {
  type    = number
  default = 2
}

variable "public_ip_address_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "gateway_ip_configuration_name" {
  type = string
}

variable "frontend_ip_configuration_name" {
  type = string
}

variable "frontend_port_name" {
  type = string
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "backend_address_pool_name" {
  type = string
}

variable "http_settings_name" {
  type = string
}

variable "backend_port" {
  type    = number
  default = 80
}

variable "backend_protocol" {
  type    = string
  default = "Http"
}

variable "listener_name" {
  type = string
}

variable "listener_protocol" {
  type    = string
  default = "Http"
}

variable "rule_name" {
  type = string
}

variable "rule_priority" {
  type    = number
  default = 100
}

variable "tags" {
  type = map(string)
}
