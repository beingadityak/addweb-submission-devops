# AddWeb Submission - DevOps Engineer

Following is the submission for the WFH assignment for the application of DevOps Engineer at AddWeb Solutions Pvt. Ltd.

## Docker Steps

[Following Application](https://github.com/habitat-sh/sample-node-app) is copied to the `/app` directory of this repository.

Steps for building the docker image and pushing to dockerhub:

1. Create an account on [DockerHub](https://hub.docker.com)
2. In your local environment, run `docker login` to login with your newly created credentials.
3. Run `docker build -t <your_dockerhub_username>/nodejs-sample-app:latest ./app` for building the image.
4. Run `docker push <your_dockerhub_username>/nodejs-sample-app:latest` to push the image to DockerHub
5. Your image was built and pushed to DockerHub!


## Terraform Steps

In the `/terraform` directory the code is provided to provision the resources for creating a new Elastic Container Service (ECS) cluster, it's task definition and service for the same. Everything will be created in a new VPC with 2 public subnets along with an Application Load Balancer (ALB) for making your task definition publicly accessible. The containers will be launched in a fargate mode, meaning no EC2 instances will be required to run your container(s).

Steps for provisioning the infra with your previously pushed docker image:

1. Initialize your AWS credentials in your local machine through AWS CLI (by running `aws configure --profile <PROFILE_NAME>`). Terraform will use this profile for provisioning the infra.
2. In `/terraform` directory, a shell script (`provision.sh`) is provided for creating the infrastructure automatically. It will ask for 2 variables, which will be writtern in `terraform.tfvars` file. This file will then be used for provisioning the infrastructure (through `terraform apply`)
3. In case you're running on Windows, you can manually write the `terraform.tfvars` file inside the `/terraform` directory, as per the sample provided in the repository.
4. Once you've changed the vars, then run `terraform init` for initializing the provider locally
5. Then you can run `terraform apply` for creating the changes in your AWS account.

Once the above steps are completed, you'll see the DNS of the ALB created as the output. you can access that DNS to verify your application.