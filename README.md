<div align="center">

# 🏗️ Terraform Azure Two-Tier Architecture

**A production-ready two-tier web application infrastructure on Microsoft Azure, provisioned using Terraform.**

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Microsoft%20Azure-Cloud-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![IaC](https://img.shields.io/badge/Infrastructure-as%20Code-success?style=for-the-badge&logo=hashicorp&logoColor=white)](https://developer.hashicorp.com/terraform)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

*Clean separation of networking, security, compute, and load balancing — ideal for learning, demos, and real-world deployments.*

</div>

---

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Project Structure](#-project-structure)
- [Infrastructure Components](#-infrastructure-components)
- [Design Principles](#-design-principles)
- [Getting Started](#-getting-started)
- [Deployment Steps](#-deployment-steps)
- [Outputs](#-outputs)
- [Cost Considerations](#-cost-considerations)
- [Security Notes](#-security-notes)
- [Use Cases](#-use-cases)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)

---

## 🏗️ Architecture Overview

![Two-Tier Azure Architecture](Image/terraform.drawio.svg)

**Traffic Flow:** `Internet → Application Gateway → Backend VMs (IIS)`

### Key Characteristics

| Feature | Details |
|---|---|
| 🌐 Frontend | Public-facing Application Gateway |
| 🖥️ Backend | Two Windows VMs running IIS 10.0 |
| 🔒 Security | Layered NSGs per subnet/tier |
| 🔁 Reproducibility | Fully declarative via Terraform |

---

## 📁 Project Structure

```text
terraform-2tier-azure/
│
├── providers.tf              # Terraform & Azure provider configuration
├── variables.tf              # Input variable declarations
├── terraform.tfvars          # Environment-specific values
│
├── network.tf                # VNet, subnets, public IP
├── network-security.tf       # Network Security Groups & rules
├── backend-vms.tf            # Windows VMs & IIS setup
├── application-gateway.tf    # Application Gateway configuration
├── outputs.tf                # Exported resource values
│
├── .terraform/               # Auto-generated provider plugins (git-ignored)
├── terraform.tfstate         # Terraform state file (git-ignored)
├── terraform.tfstate.backup  # State backup (git-ignored)
└── terraform.lock.hcl        # Provider version lock file
```

---

## ⚙️ Infrastructure Components

### 🔀 Application Gateway

| Property | Value |
|---|---|
| SKU | Standard_v2 |
| Frontend | Public (HTTP port 80) |
| Backend Pool | 2 Virtual Machines |
| Health Probes | ✅ Enabled |
| Routing Rule | Basic (HTTP) |

---

### 🖥️ Backend Virtual Machines

| Property | Value |
|---|---|
| VM Size | Standard_DS2_v2 |
| Operating System | Windows Server 2022 Datacenter |
| OS Disk | 128 GB Premium SSD |
| Web Server | IIS 10.0 |
| Count | 2 (for redundancy) |

---

### 🌐 Networking & Security

| Component | Purpose |
|---|---|
| Azure Virtual Network | Isolated network boundary |
| Dedicated Subnets | Per-tier isolation (gateway, backend) |
| Network Security Groups | Layer-specific traffic rules |
| Public IP | Attached to Application Gateway only |

Only required ports are exposed; backend VMs are **not directly reachable** from the internet.

---

## 🧠 Design Principles

| Principle | Description |
|---|---|
| **Separation of Concerns** | Networking, security, compute, and routing are isolated into separate files |
| **Low Blast Radius** | Changes in one layer don't cascade to others |
| **Environment Flexibility** | All values externalized via `terraform.tfvars` |
| **Idempotency** | Repeated `terraform apply` produces the same predictable infrastructure |

---

## 🚀 Getting Started

### Prerequisites

Before deploying, ensure you have the following:

- ✅ [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.x`
- ✅ An active [Azure Subscription](https://azure.microsoft.com/en-us/free/)
- ✅ [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated

### Azure Authentication

```bash
az login
az account set --subscription "<your-subscription-id>"
```

---

## 🛠️ Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/MOHMMADKASHIF9/terraform-2tier-azure.git
cd terraform-2tier-azure
```

### 2. Configure Variables

Edit `terraform.tfvars` with your environment-specific values:

```hcl
# terraform.tfvars (example)
resource_group_name = "rg-twotier-prod"
location            = "East US"
admin_username      = "azureadmin"
admin_password      = "YourSecurePassword123!"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

> ⚠️ Confirm the apply prompt by typing `yes` when asked.

### 6. Destroy Resources (when done)

```bash
terraform destroy
```

> 💡 Always destroy resources after testing to avoid unnecessary Azure charges.

---

## 📤 Outputs

After a successful deployment, Terraform outputs:

| Output | Description |
|---|---|
| `application_gateway_public_ip` | Public IP to access the web application |
| `vm_private_ips` | Private IPs of the backend VMs |

---

## 💰 Cost Considerations

| Resource | Cost Impact |
|---|---|
| Application Gateway Standard_v2 | Moderate — billed per hour + capacity |
| Standard_DS2_v2 VMs (x2) | Moderate — billed per hour |
| Premium SSD Disks | Low-Moderate — billed per GB/month |
| Public IP | Low |

### 💡 Cost Optimization Tips

- Switch to **Standard SSDs** for dev/test environments
- **Deallocate VMs** when not in use
- Explore [Azure Reserved Instances](https://azure.microsoft.com/en-us/pricing/reserved-vm-instances/) for long-running workloads
- Use [Azure Savings Plans](https://azure.microsoft.com/en-us/pricing/offers/savings-plan-compute/) to reduce compute costs

---

## 🔐 Security Notes

> This project uses **HTTP for simplicity**. For production deployments, the following enhancements are strongly recommended:

| Recommendation | Priority |
|---|---|
| 🔒 HTTPS listener with TLS certificates | High |
| 🛡️ Web Application Firewall (WAF) on App Gateway | High |
| 🔑 Secrets managed via Azure Key Vault | High |
| 📋 Azure Policy for compliance enforcement | Medium |
| 🔍 Azure Defender for Cloud | Medium |

**Never hardcode credentials** — use Azure Key Vault or environment variables.

---

## 🧪 Use Cases

- 📚 **Learning Terraform** with a real-world Azure scenario
- 🎤 **Interview or portfolio project** showcasing IaC skills
- 🏢 **Enterprise base template** ready for expansion
- 🔬 **Demo environment** for Azure two-tier architecture
- 🚀 **Proof of Concept** for Azure landing zones

---

## 📌 Future Enhancements

- [ ] 🔒 HTTPS listener with TLS/SSL certificates
- [ ] 🛡️ Web Application Firewall (WAF) integration
- [ ] 📈 Autoscaling backend VM scale sets
- [ ] 📊 Azure Monitor & Log Analytics workspace
- [ ] 🔄 CI/CD pipeline (GitHub Actions / Azure DevOps)
- [ ] 🗂️ Terraform remote state with Azure Storage backend
- [ ] 🌍 Multi-region deployment support
- [ ] 🔑 Azure Key Vault integration for secrets

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/your-feature-name`)
3. **Commit your changes** (`git commit -m 'Add: your feature description'`)
4. **Push to the branch** (`git push origin feature/your-feature-name`)
5. **Open a Pull Request**

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ��️ using Terraform & Azure**

⭐ If you found this useful, please **star this repository!** ⭐

**Happy Building with Terraform 🚀**

</div>
