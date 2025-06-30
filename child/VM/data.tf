data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "pip_id" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = "rohitkeyvault145"
  resource_group_name = "rg-keyvault123"
}

data "azurerm_key_vault_secret" "vmuser" {
  name         = "vmname"
  key_vault_id = data.azurerm_key_vault.kv.id
}


data "azurerm_key_vault_secret" "vmpassword" {
  name         = "vm-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_network_security_group" "nsgrohit" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
}