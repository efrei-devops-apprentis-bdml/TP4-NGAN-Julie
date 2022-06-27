# TP4-NGAN-Julie
Automatize creation of a virtual machine inside a virtual network and test its connection

# DevOps Terraform

Date Created: June 17, 2022 4:08 PM
Status: Devops

We use Terraform to automize the creation of a virtual network with a virtual machine via Azure. An Azure Virtual Machine is a complete computing unit with fewer dependencies compared to Azure Kubernetes Services and Azure Container Instances which are lighter.

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled.png)

We downloaded Terraform and Azure CLI.

We created 5 terraform files :

- [network.tf](http://network.tf) to create the resources: the network interface security group association, the network interface, the network security group, the private key, the virtual machine, the random id, the public IP
- [data.tf](http://data.tf) to reference to existing virtual network and subnet of the resource group devops-TP2
- [output.tf](http://output.tf) to extract the private key generated of the virtual machine and its public IP address to test connection with ssh
- [provider.tf](http://provider.tf) to retrieve the terraform version 3.0.0 and initialize the azurerm using the subscription key of the Azure account.
- [variable.tf](http://variable.tf)  to define the region in which our resources are located : France central

The first command we do is `terraform init`
to initialize the backend and the provider plugins in Terraform. 

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%201.png)

The next step is to make sure our configuration is well set by displaying it before applying it: `terraform plan -out main.tfplan` We save the output and use it to create the resources from the configuration.

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%202.png)

Let us create the resources :

`terraform apply main.tfplan` outputs****

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%203.png)

Note: here the resources were already created that is why it is written 0 added. The public IP address, the virtual network id and the private key to cite some are created.

The virtual machine and all other resources are present in Azure.

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%204.png)

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%205.png)

Now that we have all our resources set, we want to test the connection to the virtual machine. First, we extract the private key generated in a local file id_rsa: `terraform output -raw tls_private_key > id_rsa` 

We grant the privileges to read write and execute the file:

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%206.png)

We retrieve the public IP address:
`terraform output public_ip_address` outputs “20.216.147.130”

Let us connect to the user of the virtual machine called DevOps with its public IP address: 
`ssh -i id_rsa devops@`20.216.147.130

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%207.png)

We destroy our resources : terraform destroy

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%208.png)

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%209.png)

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%2010.png)

The resources are now gone on Azure.

We can create again our resources anytime with terraform apply:

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%2011.png)

![Untitled](DevOps%20Terraform%204a935b115de34a289c29636be45f35a9/Untitled%2012.png)