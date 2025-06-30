module "rg" {
  source   = "../child/RG"
  name     = "rohit-rg"
  location = "australia east"
}

module "rg1" {
  source   = "../child/RG"
  name     = "rohit-rg1"
  location = "australia east"
}

module "vnet" {
  depends_on          = [module.rg]
  source              = "../child/VNET"
  name                = "rohit-vnet"
  location            = "australia east"
  resource_group_name = "rohit-rg"
  address_space       = ["10.22.0.0/16"]

}

module "subnet_frontend" {
  depends_on           = [module.vnet]
  source               = "../child/SUBNET"
  name                 = "frontend-subnet"
  resource_group_name  = "rohit-rg"
  virtual_network_name = "rohit-vnet"
  address_prefixes     = ["10.22.1.0/24"]
}

module "subnet_backend" {
  depends_on           = [module.vnet]
  source               = "../child/SUBNET"
  name                 = "backend-subnet"
  resource_group_name  = "rohit-rg"
  virtual_network_name = "rohit-vnet"
  address_prefixes     = ["10.22.2.0/24"]
}

module "public_ip_frontend" {
  depends_on          = [module.subnet_frontend]
  source              = "../child/PUBLIC_IP"
  name                = "frontend_rohit_pip"
  resource_group_name = "rohit-rg"
  location            = "australia east"
}

module "public_ip_backend" {
  depends_on          = [module.subnet_backend]
  source              = "../child/PUBLIC_IP"
  name                = "backend_rohit_pip"
  resource_group_name = "rohit-rg"
  location            = "australia east"
}

module "VM_frontend" {
     depends_on = [module.public_ip_frontend, module.subnet_frontend]
  source               = "../child/VM"
  name                 = "frontend_rohit_nic"
  location             = "australia east"
  resource_group_name  = "rohit-rg"
  virtual_network_name = "rohit-vnet"
  subnet_name          = "frontend-subnet"
  pip_name             = "frontend_rohit_pip"
   vm_name = "Rohitfrontend"

  size           = "Standard_B1s"
nsg_name =  "Frontend_rohit_nsg"

  publisher = "canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"

}
module "VM_backend" {
  source              = "../child/VM"
  name                = "backend_rohit_nic"
  location            = "australia east"
  resource_group_name = "rohit-rg"
  subnet_name         = "backend-subnet"
  pip_name            = "backend_rohit_pip"
  depends_on          = [module.public_ip_backend, module.subnet_backend]
  
  
  vm_name = "Rohitbackend"
  nsg_name =  "backend_rohit_nsg"

  size           = "Standard_B1s"

  
  publisher            = "canonical"
  offer                = "0001-com-ubuntu-server-focal"
  sku                  = "20_04-lts"
  virtual_network_name = "rohit-vnet"
}

module "mssql_server" {
  depends_on = [ module.rg ]
  source = "../child/sql_server"
  sql_server_name = "rohitserver12345"
  resource_group_name = "rohit-rg"
  location = "australia east"
  administrator_login = "Student"
  administrator_login_password = "Nokia@123456789"
}

module "database" {
  depends_on = [module.mssql_server]
  source = "../child/database_sql"
  database_name = "rohitdatabase"
  
  sql_server_name = "rohitserver12345"
  resource_group_name = "rohit-rg"

  
}

module "NSGfrontend"{
  depends_on = [module.rg]
  source = "../child/NSG"
  nsg_name = "Frontend_rohit_nsg"
  location = "australia east"
  resource_group_name = "rohit-rg"
  priority ="100"
}


module "NSGbackend" {
  depends_on = [module.rg]
  source = "../child/NSG"
  nsg_name = "backend_rohit_nsg"
  location = "australia east"
  resource_group_name = "rohit-rg"
  priority ="101"
}






