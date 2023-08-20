# Web Application Setup and Deployment

This repository contains scripts and configuration files to set up and deploy a simple "Apple count (: " web application with Node.js, MongoDB, and ECS containers.

## Prerequisites
- AWS account.
- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Minikube: [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- Helm: [Install Helm] (curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash)

## Getting Started

1. Install the Jenkins Helm-Chart:

   ```bash
   helm repo add jenkins https://charts.jenkins.io
   helm repo update
   helm upgrade --install myjenkins jenkins/jenkins
   -- (open another terminal):
   kubectl port-forward svc/myjenkins 8080:8080

2. Access Jenkins in your browser:
Open your web browser and navigate to http://localhost:8080

    The username is: admin <br />
    To get the password run:

   ```bash
   kubectl exec --namespace default -it svc/myjenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo


3. Create a pipeline, and go to pipeline definition. <br />
    Fork this git repository, and in the file 'docker-compose.yaml' , change 'x-aws-vpc' value to your default vpc ID, ( you can find the vpc ID in AWS -> VPC -> VPC ID ) and make sure that vpc has 2 subnets in 2 diffrent AZ's. <br />
    In definiton choose pipeline script from SCM. <br />
    In SCM choose Git. <br />
    Copy and Paste your forked git repository- HTTPS URL. <br />
    Change the Branch Specifier from */master to '*/main' . <br />
    Script Path should be : 'Jenkinsfile' . <br />
    Apply and save your pipeline. <br />
    Go to Manage Jenkins -Credentials - global - and add 2 secret files:   First ID: AWS_ACCESS_KEY_ID  -- paste you aws ID token. Second ID: AWS_SECRET_ACCESS_KEY -- paste your aws secret access key. <br />
    Run a build for you pipeline. <br />
    When the build is over, go to your AWS account, go to EC2-Load Balancers and copy the ALB url and paste it in your browesr : myapp-LoadB-1O8HHXI66FTC3-00802508ed3acb2f.elb.us-east-1.amazonaws.com:3000 . ( your the load balancer will have a diffrent url, don't forget to add :3000 to the url).


# Project Structure
app/ : Contains the Node.js application files, and the Dockerfile I used to build the app's image. <br />
docker-compose.yml: Docker Compose file you can use to set up the containers locally before deploying it on AWS. <br />
Jenkinsfile- Use this file to create your pipeline. <br />
setup.sh- If you only want to run the containers locally, run ./setup.sh . open your browser and paste : 'localhost:3000' <br />
delete.sh- If you ran the containers locally' run ./delete.sh to delete the containers and the images.
# Customization
Don't forget to change the 'x-aws-vpc' value in the 'docker-compose.yaml' to your VPC. <br />
Add your AWS token ccredentials as secret text in Jenkins. First ID: AWS_ACCESS_KEY_ID, Second ID: AWS_SECRET_ACCESS_KEY <br />
# Notes
Ensure you have all the Prerequisites. <br />
Don't forget to delete all the AWS resources when you are done with them.


