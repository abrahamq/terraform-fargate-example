# Set the ~/.aws/credentials
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

