provider "azurerm" {
    subscription_id = "86d22e9c-bc56-49c3-a93a-0586bbb4ee79"
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    version = "=2.0.0"
    features {}
}

#Create a resource group if it doesn't exist
# resource "azurerm_resource_group" "rg" {
#     name     = "testrg"
#     location = "West US 2"

# }

data "azurerm_resource_group" "image" {
  name = "testrg"
}

data "azurerm_image" "image" {
  name                = var.ami_name
  resource_group_name = data.azurerm_resource_group.image.name
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = "testrg"
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "lbip" {
    name                         = "pubip"
    location                     = "East US"
    resource_group_name          = "testrg"
    allocation_method            = "Dynamic"

    # tags = {
    #     environment = "Terraform Demo"
    # }
}


Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "East US"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
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

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "vmnic"
    location                  = "East US"
    resource_group_name       = "testrg"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


# Create virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "test-vm"
  location              = "East US"
  resource_group_name   = "testrg"
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  # storage_image_reference {
  #       publisher = "cloudsec"
  #       offer     = "centos-1"
  #       sku       = "centos-1-7"
  #       version   = "latest"
  # }

  storage_profile_image_reference {
  id=data.azurerm_image.image.id
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "azurehost"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvZq7Y2gWeXuD/xxzlo5lYXw5ZMhlusqg/5F3K1KvW7cHi9sXOf76QI0jAKijaFqMcMyNpjaMuEOMSgA+MoxPh9CSkfVgGt3toBvwVEs/7fFif7dL6LuWi+52Pmizh7nUg3dRbuWPjmT9jlnnmV4A4A8K/FN/Zjb5lQofsM/fRY+nGq/UFU+bJu/ti5V15ExJoB9cK3cvDComD0W+MIWBWttrCF2DsEF2TB2Ymex4c2iF/ebVTgoxpFyCkjVPEc58/q8lvoLyiN7CovKf7ThjOMrDVxTl+6cCWfP2WHP8634wvQ6ChWFHOtvl7EduPOrU121fhRqyUvNnJxcRAKt/"
      path = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}