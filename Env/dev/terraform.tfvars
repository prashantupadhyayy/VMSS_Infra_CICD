rgs = {
  devrg1 = {
    name     = "devrginfra"
    location = "centralindia"
  }
}

stgs = {
  devstg1 = {
    name                     = "devrgstg"
    location                 = "centralindia"
    resource_group_key       = "devrg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

vnets = {
  devvnet1 = {
    name               = "dev-vnet"
    location           = "centralindia"
    resource_group_key = "devrg1"
    address_space      = ["10.0.0.0/16"]
    dns_servers        = ["10.0.0.4", "10.0.0.5"]
  }
}

subnets = {
  devsubnet1 = {
    name               = "dev-subnet-vmss"
    location           = "centralindia"
    vnet_key           = "devvnet1"
    resource_group_key = "devrg1"
    address_prefixes   = ["10.0.0.0/24"]
  }

  devsubnet2 = {
    name               = "CSX-dev-subnet-appgw"
    location           = "centralindia"
    vnet_key           = "devvnet1"
    resource_group_key = "devrg1"
    address_prefixes   = ["10.0.1.0/24"]
  }
}

NSGs = {
  devNSG1 = {
    name               = "CSX-dev-nsg"
    location           = "centralindia"
    resource_group_key = "devrg1"

    security_rules = {
      allow-all = {
        name                       = "CSX-dev-Security-Rule"
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
      environment = "dev"
      project     = "csx"
    }
  }
}

public_ips = {

  devpublic_ip1 = {
    name               = "pip-loadbalancer"
    location           = "centralindia"
    resource_group_key = "devrg1"
    allocation_method  = "Static"
    sku                = "Standard"
  }

  devpublic_ip2 = {
    name               = "pip-appgw"
    location           = "centralindia"
    resource_group_key = "devrg1"
    allocation_method  = "Static"
    sku                = "Standard"
  }
}


load_balancers = {
  devloadbalancer = {
    lb_name               = "CSX-dev-loadbalancer"
    location              = "centralindia"
    resource_group_key    = "devrg1"
    frontend_ip           = "CSX-dev-frontend-ip"
    public_ip_key         = "devpublic_ip1"
    backend_pool_name     = "CSX-dev-backend-pool"
    probe_name            = "CSX-dev-probe"
    lb_rule_name          = "CSX-dev-lb-rule"
    ip_configuration_name = "ipconfig1"
  }
}

virtual_machine_scale_sets = {
  "vmss1" = {
    name               = "dev-vmss-csx"
    resource_group_key = "devrg1"
    subnet_key         = "devsubnet1"
    location           = "centralindia"
    instance_count     = 2
    vmss_size            = "Standard_D2s_v3"

    admin_username = "riya"
    admin_password = "verma1234@1234"

    image_publisher = "Canonical"
    image_offer     = "0001-com-ubuntu-server-focal"
    image_sku       = "20_04-lts"
    image_version   = "latest"

    os_disk_storage_account_type = "Standard_LRS"
    os_disk_size_gb              = 30
    os_disk_caching              = "ReadWrite"

    nic_name = "dev-vmss-nic"

    tags = {
      environment = "dev"
      project     = "csx"
      owner       = "riya"
    }
  }
}


application_gateways = {
  "appgw1" = {
    app_gw_name = "dev-appgw-csx"

    resource_group_key = "devrg1"
    location           = "centralindia"
    public_ip_key      = "devpublic_ip2"
    subnet_key         = "devsubnet2"

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
      environment = "dev"
      project     = "csx"
    }
  }
}
