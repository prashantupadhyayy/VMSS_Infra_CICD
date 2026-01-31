module "rgs" {
  source   = "../module/resource_group"
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}

module "stgs" {
  source                   = "../module/storage_account"
  for_each                 = var.stgs
  depends_on               = [module.rgs]
  name                     = each.value.name
  location                 = each.value.location
  resource_group_name      = module.rgs[each.value.resource_group_key].rg_name
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

module "vnets" {
  source              = "../module/virtual_network"
  for_each            = var.vnets
  depends_on          = [module.rgs]
  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
}

module "subnets" {
  source               = "../module/subnet"
  for_each             = var.subnets
  depends_on           = [module.vnets]
  name                 = each.value.name
  location             = each.value.location
  virtual_network_name = module.vnets[each.value.vnet_key].vnet_name
  resource_group_name  = module.rgs[each.value.resource_group_key].rg_name
  address_prefixes     = each.value.address_prefixes
}


module "NSGs" {
  source         = "../module/NSG"
  for_each       = var.NSGs
  depends_on     = [module.subnets]
  name           = each.value.name
  location       = each.value.location
  resource_group = module.rgs[each.value.resource_group_key].rg_name

}

module "public_ips" {
  source              = "../module/public_ip"
  for_each            = var.public_ips
  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  allocation_method   = each.value.allocation_method
}
module "load_balancers" {
  source     = "../module/load_balancer"
  for_each   = var.load_balancers
  depends_on = [module.public_ips]

  name                  = each.value.lb_name
  location              = each.value.location
  resource_group_name   = module.rgs[each.value.resource_group_key].rg_name
  frontend_ip           = each.value.frontend_ip
  public_ip_address_id  = module.public_ips[each.value.public_ip_key].id
  backend_pool_name     = each.value.backend_pool_name
  probe_name            = each.value.probe_name
  lb_rule_name          = each.value.lb_rule_name
  ip_configuration_name = each.value.ip_configuration_name

}



module "virtual_machine_scale_sets" {
  source   = "../module/virtual_machine_scale_sets"
  for_each = var.virtual_machine_scale_sets

  vmss_name           = each.value.name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  vmss_size           = each.value.vm_size
  instance_count      = each.value.instance_count

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  image_publisher = each.value.image_publisher
  image_offer     = each.value.image_offer
  image_sku       = each.value.image_sku
  image_version   = each.value.image_version

  os_disk_storage_account_type = each.value.os_disk_storage_account_type
  os_disk_size_gb              = each.value.os_disk_size_gb
  os_disk_caching              = each.value.os_disk_caching

  nic_name = each.value.nic_name

  subnet_id = module.subnets[each.value.subnet_key].subnet_id
  tags      = each.value.tags
}


module "application_gateways" {
  source   = "../module/application_gateway"
  for_each = var.application_gateways

  app_gw_name         = each.value.app_gw_name
  location            = each.value.location
  resource_group_name = module.rgs[each.value.resource_group_key].rg_name
  sku_name            = each.value.sku_name
  capacity            = each.value.capacity

  public_ip_address_id = module.public_ips[each.value.public_ip_key].id
  subnet_id            = module.subnets[each.value.subnet_key].subnet_id

  gateway_ip_configuration_name  = each.value.gateway_ip_configuration_name
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_port_name             = each.value.frontend_port_name
  frontend_port                  = each.value.frontend_port

  backend_address_pool_name = each.value.backend_address_pool_name
  http_settings_name        = each.value.http_settings_name
  backend_port              = each.value.backend_port
  backend_protocol          = each.value.backend_protocol

  listener_name     = each.value.listener_name
  listener_protocol = each.value.listener_protocol
  rule_name         = each.value.rule_name
  rule_priority     = each.value.rule_priority

  tags = each.value.tags
}
