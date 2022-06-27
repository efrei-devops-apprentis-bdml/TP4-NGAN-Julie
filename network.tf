resource "azurerm_public_ip" "PlublicIP_20180776" {
  name                = "PublicIP_20180476"
  location            = var.region
  resource_group_name = "devops-TP2"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "NSG_20180476" {
  name                = "NetworkSecurityGroup_20180476"
  location            = var.region
  resource_group_name = "devops-TP2"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "NetworkInterface_20180476" {
  name                = "NIC_20180476"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.tp4.name

  ip_configuration {
    name                          = "NicConfiguration_20180476"
    subnet_id                     = data.azurerm_subnet.tp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PlublicIP_20180776.id
  }
}

resource "azurerm_network_interface_security_group_association" "NetWorkInterfaceSecurityGroupAssociation_20180476" {
  network_interface_id      = azurerm_network_interface.NetworkInterface_20180476.id
  network_security_group_id = azurerm_network_security_group.NSG_20180476.id
}

resource "random_id" "randomId" {
  keepers = {
    resource_group = data.azurerm_resource_group.tp4.name
  }

  byte_length = 8
}


resource "tls_private_key" "ssh_20180476" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "devops-20180476" {
  name                  = "devops-20180476"
  location              = data.azurerm_resource_group.tp4.location
  resource_group_name   = data.azurerm_resource_group.tp4.name
  network_interface_ids = [azurerm_network_interface.NetworkInterface_20180476.id]
  size                  = "Standard_D2s_v3"

  # This is where we pass our cloud-init.
  custom_data = data.template_cloudinit_config.config.rendered


  os_disk {
    name                 = "mynewOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name                   = "mynewvm"
  admin_username                  = "devops"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.ssh_20180476.public_key_openssh
  }

}

