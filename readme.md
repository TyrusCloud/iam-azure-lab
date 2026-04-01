# Azure IAM Lab  
Terraform + Azure + Active Directory Domain Controller

## Project Overview

This project demonstrates how to deploy a secure Azure environment using Terraform
and configure a Windows Server Domain Controller for Identity and Access Management (IAM) testing.

The goal of this lab is to simulate a real enterprise / government cloud environment
with private networking, secure remote access, and Active Directory.

This is Part 1 of a multi-part IAM lab.

Part 1 focuses on infrastructure and domain controller deployment.
Part 2 will focus on Active Directory users, groups, and OU design.

---

## Architecture

Resources deployed:

- Resource Group
- Virtual Network
- Subnets
- Network Security Group (NSG)
- Windows Server VM
- Network Interface
- Azure Bastion / RDP access
- Active Directory Domain Services
- Domain Controller

Network design:

- servers-subnet → Windows Server VM
- AzureBastionSubnet → Bastion host
- NSG allows RDP only from Virtual Network

---

## Tools Used

- Terraform
- Microsoft Azure
- Windows Server 2019
- Active Directory Domain Services
- Azure Networking
- PowerShell

---

## Deployment Steps

### 1. Clone repo

### 3. Configure variables

Create terraform.tfvars

### 4. Deploy

### 5. Connect to VM

Use Azure Bastion or RDP.

### 6. Install Active Directory

### 7. Promote to Domain Controller

---

## Security Notes

- VM deployed in private subnet
- NSG restricts inbound traffic
- RDP allowed only from Virtual Network
- terraform.tfvars excluded using .gitignore

---

## Next Steps

Part 2 will include:

- Organizational Units (OU)
- Users
- Groups
- Group membership
- IAM structure design
- Domain join for additional VM
