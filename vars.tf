variable "azurerm_resource_group_name" {
  default = "terraform-demo-mu"
}
 
variable "azurerm_keyvault_name" {
    default = "keyvaultmu"
}

variable "azurerm_resource_group_location" {
  default = "UK South"
}

variable "vm_names" {
  default = ["vm-demo-01", "vm-demo-02", "vm-demo-03"]
}

variable "lb_ports" {
  default = ["80","443"]
}

variable "tag_role" {
  default = "frontend"
}

variable "vm_zones" {
  default = ["1", "2", "3"]
}

variable "azure_environment" {
  default = "UAT"
}

variable "azure_costcentre" {
  default = "demo"
}

variable "azurerm_lbext_name" {
  default = "exlb-frontend-demo"
}

variable "azurerm_lbextip_name" {
  default = "exip-frontend-demo"
}

variable "azurerm_vm_ip_address" {
  default = ["10.0.1.10", "10.0.1.20", "10.0.1.30"]
}

variable "admin_username" {
  default = "mikehaslam"
}
