# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "iam-lab-rg"
  location = var.location
}


# VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "iam-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "servers_subnet" {
  name                 = "servers-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"   # must be exactly this
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# NSG 
resource "azurerm_network_security_group" "nsg" {
  name                = "iam-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Allow RDP from VirtualNetwork (Bastion)
resource "azurerm_network_security_rule" "allow_rdp_vnet" {
  name                        = "Allow-RDP-From-VNet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "3389"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Optional: allow ping inside VNet
resource "azurerm_network_security_rule" "allow_icmp_vnet" {
  name                        = "Allow-ICMP-VNet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Associate NSG with servers subnet
resource "azurerm_subnet_network_security_group_association" "servers_nsg_assoc" {
  subnet_id                 = azurerm_subnet.servers_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# NIC & VM
resource "azurerm_network_interface" "nic" {
  name                = "dc-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.servers_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                  = "dc1"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = "Standard_D2s_v4" 
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Bstion Host 
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "iam-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
 
  
  ip_configuration {
    name                 = "bastion-ip"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
