#!/bin/bash

echo "Enter your AWS Profile: ";
read -n aws_profile;
echo "Enter the docker image name for using with ECS: ";
read -n docker_image

if [ -e $aws_profile ] || [ -e $docker_image ]; then
    echo "one or more vars is missing."
    cat <<EOF
Required variables:
    1. AWS Profile
    2. Docker Image name (eg. jenkins/jenkins:latest)
EOF
else
    cat <<EOF > terraform.tfvars
profile = "${aws_profile}"
image_name = "${docker_image}"
EOF

    if ! [ -x "$(command -v terraform)" ]; then
        echo "Terraform is not installed! Download it from https://terraform.io/download"
        exit 1;
    else
        echo "Running Terraform for creating your infrastructure! ";
        terraform init;
        terraform fmt;
        terraform apply;
    fi
fi