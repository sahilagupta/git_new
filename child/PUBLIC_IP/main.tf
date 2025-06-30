resource "azurerm_public_ip" "publicrohit" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

 
}

variable "name" {
    type = string
  
}

variable "resource_group_name" {
    type = string
  
}


variable "location" {
    type = string
  
}