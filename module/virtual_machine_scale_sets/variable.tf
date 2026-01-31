variable "vmss_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vmss_size" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "os_disk_storage_account_type" {
  type = string
}

variable "os_disk_size_gb" {
  type = number
}

variable "os_disk_caching" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "backend_address_pool_id" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}
