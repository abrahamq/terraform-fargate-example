# Install terraform
[Get terraform](https://releases.hashicorp.com/terraform/0.12.10/)
```
mkdir /Applications/terraform.app
cp terraform /Applications/terraform.app/terraform
```

in ~/.bash_profile:
```
export PATH="$PATH:/Applications/terraform.app"
alias tf='Applications/terraform.app/terraform"
```


# Set the ~/.aws/credentials

```
mkdir ~/.aws
touch ~/.aws/credentials
open ~/.aws/credentials
```


With the terraform-flux user from last pass
Then:
```
export AWS_PROFILE=terraform-flux
tf workspace select fluxland
tf plan -out=flux.plan
tf apply flux.plan
```

# Fargate with Terraform

Example repository to deploy an ECS cluster hosting a web application.

