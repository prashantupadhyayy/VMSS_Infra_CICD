variable "rgs" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "stgs" {
  type = map(object({
    name                     = string
    location                 = string
    resource_group_key       = string
    account_tier             = string
    account_replication_type = string
  }))
}

variable "vnets" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    address_space      = list(string)
    dns_servers        = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    name               = string
    location           = string
    vnet_key           = string
    resource_group_key = string
    address_prefixes   = list(string)
  }))
}

variable "NSGs" {
  description = "Map of Network Security Groups"
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string

    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))

    tags = map(string)
  }))
}


variable "public_ips" {
  type = map(object({
    name               = string
    location           = string
    resource_group_key = string
    allocation_method  = string
  }))
}

variable "load_balancers" {
  type = map(object({
    lb_name               = string
    location              = string
    resource_group_key    = string
    frontend_ip           = string
    public_ip_key         = string
    backend_pool_name     = string
    probe_name            = string
    lb_rule_name          = string
    ip_configuration_name = string
  }))
}


variable "virtual_machine_scale_sets" {
  description = "Map of VM Scale Sets configuration"
  type = map(object({
    name               = string
    resource_group_key = string
    subnet_key         = string
    location           = string
    instance_count     = number
    vmss_size            = string

    admin_username = string
    admin_password = string

    image_publisher = string
    image_offer     = string
    image_sku       = string
    image_version   = string

    os_disk_storage_account_type = string
    os_disk_size_gb              = number
    os_disk_caching              = string

    nic_name = string

    tags = map(string)
  }))
}

variable "application_gateways" {
  description = "Map of Application Gateway configurations"
  type = map(object({
    app_gw_name = string

    resource_group_key = string
    location           = string
    public_ip_key      = string
    subnet_key         = string

    sku_name = string
    capacity = number

    gateway_ip_configuration_name  = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    frontend_port                  = number

    backend_address_pool_name = string
    http_settings_name        = string
    backend_port              = number
    backend_protocol          = string

    listener_name     = string
    listener_protocol = string

    rule_name     = string
    rule_priority = number

    tags = map(string)
  }))
}

