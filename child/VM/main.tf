


resource "azurerm_network_interface" "rohitnic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic" 
    public_ip_address_id = data.azurerm_public_ip.pip_id.id
    
  }
  
}
resource "azurerm_network_interface_security_group_association" "nsgnicassociate" {
  depends_on = [ azurerm_network_interface.rohitnic,data.azurerm_network_security_group.nsgrohit ]
  network_interface_id      = azurerm_network_interface.rohitnic.id
    


   network_security_group_id = data.azurerm_network_security_group.nsgrohit.id
  }



resource "azurerm_linux_virtual_machine" "rohitvm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  disable_password_authentication = false
  admin_username      = data.azurerm_key_vault_secret.vmuser.value
  admin_password  = data.azurerm_key_vault_secret.vmpassword.value
   network_interface_ids = [
    azurerm_network_interface.rohitnic.id,
  ]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
)

}

