resource "azurerm_virtual_network" "vnetrohit" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
 
}

variable "name" {
    type = string
  
}

variable "location" {
    type = string
  
}

variable "resource_group_name" {
    type = string
  
}

variable "address_space" {
    type = list(string)
  
}

