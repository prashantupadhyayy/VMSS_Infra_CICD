rgs = {
  prodrg1 = {
    name     = "prod-CSXinfra"
    location = "centralindia"
  }
}

stgs = {
  prodstg1 = {
    name                     = "prodcsxstg"
    location                 = "centralindia"
    resource_group_key       = "prodrg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  prodvnet1 = {
    name               = "CSX-prod-vnet"
    location           = "centralindia"
    resource_group_key = "prodrg1"
    address_space      = ["10.0.0.0/16"]
    dns_servers        = ["10.0.0.4", "10.0.0.5"]
  }
}

subnets = {
  prodsubnet1 = {
    name               = "CSX-prod-subnet-vmss"
    location           = "centralindia"
    vnet_key           = "prodvnet1"
    resource_group_key = "prodrg1"
    address_prefixes   = ["10.0.0.0/24"]
  }

  prodsubnet2 = {
    name               = "CSX-prod-subnet-appgw"
    location           = "centralindia"
    vnet_key           = "prodvnet1"
    resource_group_key = "prodrg1"
    address_prefixes   = ["10.0.1.0/24"]
  }
}

NSGs = {
  prodNSG1 = {
    name               = "CSX-prod-nsg"
    location           = "centralindia"
    resource_group_key = "prodrg1"

    security_rules = {
      allow-all = {
        name                       = "CSX-prod-Security-Rule"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }

    tags = {
      environment = "prod"
      project     = "csx"
    }
  }
}

public_ips = {

  prodpublic_ip1 = {
    name               = "pip-loadbalancer"
    location           = "centralindia"
    resource_group_key = "prodrg1"
    allocation_method  = "Static"
  }

  prodpublic_ip2 = {
    name               = "pip-appgw"
    location           = "centralindia"
    resource_group_key = "prodrg1"
    allocation_method  = "Static"
  }
}


load_balancers = {
  prodloadbalancer = {
    lb_name               = "CSX-prod-loadbalancer"
    location              = "centralindia"
    resource_group_key    = "prodrg1"
    frontend_ip           = "CSX-prod-frontend-ip"
    public_ip_key         = "prodpublic_ip1"
    backend_pool_name     = "CSX-prod-backend-pool"
    probe_name            = "CSX-prod-probe"
    lb_rule_name          = "CSX-prod-lb-rule"
    ip_configuration_name = "ipconfig1"
  }
}

virtual_machine_scale_sets = {
  "vmss1" = {
    name               = "prod-vmss-csx"
    resource_group_key = "prodrg1"
    subnet_key         = "prodsubnet1"
    location           = "centralindia"
    instance_count     = 2
    vm_size            = "Standard_B2s"

    admin_username = "riya"
    admin_password = "verma1234@1234"

    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-focal"
    image_sku       = "20_04-lts"
    image_version   = "latest"

    os_disk_storage_account_type = "Standard_LRS"
    os_disk_size_gb              = 30
    os_disk_caching              = "ReadWrite"

    nic_name = "prod-vmss-nic"

    tags = {
      environment = "prod"
      project     = "csx"
      owner       = "riya"
    }
  }
}


application_gateways = {
  "appgw1" = {
    app_gw_name = "prod-appgw-csx"

    resource_group_key = "prodrg1"
    location           = "centralindia"
    public_ip_key      = "prodpublic_ip2"
    subnet_key         = "prodsubnet2"

    sku_name = "Standard_v2"
    capacity = 2

    gateway_ip_configuration_name  = "gw-ip-config"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "frontend-port-80"
    frontend_port                  = 80

    backend_address_pool_name = "backend-pool"
    http_settings_name        = "http-settings"
    backend_port              = 80
    backend_protocol          = "Http"

    listener_name     = "http-listener"
    listener_protocol = "Http"

    rule_name     = "rule-80"
    rule_priority = 100

    tags = {
      environment = "prod"
      project     = "csx"
    }
  }
}
