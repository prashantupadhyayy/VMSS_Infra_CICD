rgs = {
  qarg1 = {
    name     = "qa-CSXinfra"
    location = "centralindia"
  }
}

stgs = {
  qastg1 = {
    name                     = "qacsxstg"
    location                 = "centralindia"
    resource_group_key       = "qarg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  qavnet1 = {
    name               = "CSX-qa-vnet"
    location           = "centralindia"
    resource_group_key = "qarg1"
    address_space      = ["10.0.0.0/16"]
    dns_servers        = ["10.0.0.4", "10.0.0.5"]
  }
}

subnets = {
  qasubnet1 = {
    name               = "CSX-qa-subnet-vmss"
    location           = "centralindia"
    vnet_key           = "qavnet1"
    resource_group_key = "qarg1"
    address_prefixes   = ["10.0.0.0/24"]
  }

  qasubnet2 = {
    name               = "CSX-qa-subnet-appgw"
    location           = "centralindia"
    vnet_key           = "qavnet1"
    resource_group_key = "qarg1"
    address_prefixes   = ["10.0.1.0/24"]
  }
}

NSGs = {
  qaNSG1 = {
    name               = "CSX-qa-nsg"
    location           = "centralindia"
    resource_group_key = "qarg1"

    security_rules = {
      allow-all = {
        name                       = "CSX-qa-Security-Rule"
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
      environment = "qa"
      project     = "csx"
    }
  }
}

public_ips = {

  qapublic_ip1 = {
    name               = "pip-loadbalancer"
    location           = "centralindia"
    resource_group_key = "qarg1"
    allocation_method  = "Static"
  }

  qapublic_ip2 = {
    name               = "pip-appgw"
    location           = "centralindia"
    resource_group_key = "qarg1"
    allocation_method  = "Static"
  }
}


load_balancers = {
  qaloadbalancer = {
    lb_name               = "CSX-qa-loadbalancer"
    location              = "centralindia"
    resource_group_key    = "qarg1"
    frontend_ip           = "CSX-qa-frontend-ip"
    public_ip_key         = "qapublic_ip1"
    backend_pool_name     = "CSX-qa-backend-pool"
    probe_name            = "CSX-qa-probe"
    lb_rule_name          = "CSX-qa-lb-rule"
    ip_configuration_name = "ipconfig1"
  }
}

virtual_machine_scale_sets = {
  "vmss1" = {
    name               = "qa-vmss-csx"
    resource_group_key = "qarg1"
    subnet_key         = "qasubnet1"
    location           = "centralindia"
    instance_count     = 2
    vmss_size            = "Standard_B2s"

    admin_username = "riya"
    admin_password = "verma1234@1234"

    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-focal"
    image_sku       = "20_04-lts"
    image_version   = "latest"

    os_disk_storage_account_type = "Standard_LRS"
    os_disk_size_gb              = 30
    os_disk_caching              = "ReadWrite"

    nic_name = "qa-vmss-nic"

    tags = {
      environment = "qa"
      project     = "csx"
      owner       = "riya"
    }
  }
}


application_gateways = {
  "appgw1" = {
    app_gw_name = "qa-appgw-csx"

    resource_group_key = "qarg1"
    location           = "centralindia"
    public_ip_key      = "qapublic_ip2"
    subnet_key         = "qasubnet2"

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
      environment = "qa"
      project     = "csx"
    }
  }
}
