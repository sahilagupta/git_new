resource "azurerm_resource_group" "rg-rohit" {
  name     = var.name
  location = var.location
    tags     = {}  # Azure best practice: avoid empty tag maps
}

variable "name" {
    type = string
}
variable "location" {
    type = string
}