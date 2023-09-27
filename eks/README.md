# EKS - Elastic Kubernetes Service

## Table of Contents

1. [Project Overview](#project-overview)
   - Description of the project's purpose and goals.
2. [Prerequisites](#prerequisites)

   - Requirements for running and deploying the project.

3. [Dockerization](#dockerization)

   - Building Docker images and running containers.

4. [Setting up AWS infrastructure](#setting-up-aws-infrastructure)
   - Creating VPC (virtual private cloud) and needed EC2 instances.
5. [Kubernetes Deployment](#kubernetes-deployment)
   - Deploying the application to a Kubernetes cluster.

<br/><br/><br/><br/>

## Project Overview

\
Welcome to the EKS demo Documentation! This comprehensive guide provides detailed insights into a dynamic DevOps project that leverages modern cloud technologies.

\
**Cloud-Centric Approach:**
\
Explore how this project harnesses the power of leading cloud providers, such as AWS, Azure, or GCP, to deploy scalable and resilient applications.

\
**Dockerization and Kubernetes:**
\
Dive into the world of containerization with Docker and learn how Kubernetes orchestrates containers for efficient application management.

\

<br/><br/><br/>

## Prerequisites

- **Node.js Backend REST API:** I have developed the Node.js REST API already. You can find the project [here](https://github.com/sanjueranga/member-portal).

- **React Frontend:** I have developed the React frontend already. You can find the project [here](https://github.com/sanjueranga/member-portal).

<br/><br/><br/>

## Dockerization

> **Installing and Configuring Docker on Linux**

Follow these steps to install and configure Docker on your Linux machine. These instructions are generally applicable to popular Linux distributions like Ubuntu, CentOS, and Debian.

**Note:** Ensure that you have administrative (root) or sudo privileges on your Linux machine.

1.  **Update Package Lists:**

    Open a terminal and run the following command to update the package lists:

    ```bash
    sudo apt update  # For Ubuntu/Debian
    # or
    sudo yum update  # For CentOS
    ```

    Install dependencies that are required for the Docker installation:
    For Ubuntu/Debian:

    ```bash
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    ```

    Add Docker Repository (Ubuntu/Debian Only):

    For Ubuntu and Debian, add Docker's official GPG key and repository:

    ```bash

      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

      echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    ```

    Install Docker Engine:

    Update the package list one more time and then install Docker:

    ```bash
      sudo apt update  # For Ubuntu/Debian
          # or
      sudo yum makecache fast  # For CentOS

      sudo apt install docker-ce  # For Ubuntu/Debian
          # or
      sudo yum install docker-ce  # For CentOS

    ```

    Enable and Start Docker:

    Start the Docker service and enable it to start on boot:

    ```bash
    sudo systemctl start docker
    sudo systemctl enable docker

    ```

    Verify Docker Installation:

    Check if Docker is installed and running by running the following command:

    ```bash
       sudo docker --version


    ```

> **Dockerizing API**

**Include docker file into root directory of Node app**

\
![Alt text](pics/dockerfile.png)

**Build the Docker Image**

```
sudo docker build . -t my-node-api
```

\
![Alt text](pics/cImgTO.png)

** Check created docker images**

```
docker images
```

![Alt text](pics/imgs.png)

you can see our docker image is created

**Run Docker Image**

```
docker run -p 8060:8060 -d my-node-api
```

we can add environment when running `docker run -e ALLOWED_URL=value -p 8060:8060 -d my-node-api`

**See running docker images**

`docker ps`

\
![Alt text](pics/runningimgs.png)

you can see image is currently running on port 8060

\
**Testing API with Postman**

![Alt text](pics/postman.png)
API call works properly

**Stoping running container**

```
sudo docker stop  container-id
```

> **Dockerizing REACT frontend**

**Dockerfile**

```
# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the rest of your application's source code
COPY . .



# Build your React app
RUN npm run build

# Expose the port your React app will run on (usually 3000)
EXPOSE 3000

# Define the command to run your React app
CMD ["npm", "start"]
```

Dokcerignore file

```
.env
node_modules
```

**To create the Docker Image**
use the same command as above
`sudo docker build . -t my-react-app`

**To Run**

```
sudo docker run -e REACT_APP_API_URL=http://localhost:8060 -e REACT_APP_API_KEY=value -p 3000:3000 my-react-app

```

Now we can see the both frontend and backend running as docker images.

**Make sure allowing correct URLs in CORS in node environments**

**Here an additional bash script to clear all containers after test**

```bash
#!/bin/bash

# Get a list of all containers (both running and exited)
container_list=$(docker ps -aq)

# Check if there are any containers to stop and remove
if [ -n "$container_list" ]; then
  # Iterate through each container ID, stop it, and then remove it
  for container_id in $container_list; do
    echo "Stopping container: $container_id"
    docker stop "$container_id"

    echo "Removing container: $container_id"
    docker rm "$container_id"
  done
else
  echo "No containers to stop and remove."
fi

```

<br/><br/><br/>

## Setting up AWS infrastructure

> **Creating VPC**

Here i used the template AWS provides ,VPC for EKS . provided in this documentation

https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html

> Go to cloudFormation

create new Stack

![Alt text](pics/cfstack.png)
Enter the template link in S3 URL.

this will create a VPC for our EKS cluster, with 2 public, 2 private subnets

<br/><br/><br/>

## Kubernetes Deployment

> **Creating EKS cluster**

Using EKS management console, create new cluster

![Alt text](pics/clusterconfig.png)

Network settings

![Alt text](pics/clusternet.png)

Security group created by our VPC

![Alt text](pics/clustersec.png)

Once the Cluster is created. Create a Node Group

![Alt text](pics/clusterac.png)

> **Creating Node Group**

![Alt text](pics/nodeg.png)

**Selecting EC2 instances type**

![Alt text](pics/ec2type.png)

For now we set size is 2, we can change it later

Network configuration

![Alt text](pics/ec2n.png)

**EC2 are created**

![Alt text](pics/ec2l.png)

Access one of EC2 using SSH. OR in local machine

- install AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

- Kubectl
  https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

Then update kubeconfig

```
   aws eks update-kubeconfig --region region-code --name my-cluster
```

Then you can see Cluster details

`kubectl get nodes`

![Alt text](pics/getnodes.png)

> **Create Deployments**

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-js-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-js
  template:
    metadata:
      labels:
        app: node-js
    spec:
      containers:
        - name: node-js
          image: sanjueranga/my-node-api:latest
          ports:
            - containerPort: 8060
          env:
            - name: MONGODB_URL
              value: ""
            - name: NODE_ENV
              value: "production"
            - name: JWT_SECRET
              value: "abc123"
            - name: CSUP_API_KEY
              value: ""
---
apiVersion: v1
kind: Service
metadata:
  name: node-js-service
spec:
  type: LoadBalancer
  selector:
    app: node-js
  ports:
    - port: 8060
      targetPort: 8060
      protocol: TCP


```

**Frontend**

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-js-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-js
  template:
    metadata:
      labels:
        app: react-js
    spec:
      containers:
        - name: react-js
          image: sanjueranga/my-react-app:latest
          ports:
            - containerPort: 3000
          env:
            - name: REACT_APP_API_URL
              value: $API_ELB_PUBLIC_FQDN
            - name: REACT_APP_CSUP_API_KEY
              value: ""

---
apiVersion: v1
kind: Service
metadata:
  name: react-js-service
spec:
  type: LoadBalancer
  selector:
    app: react-js
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000

```

> **Apply Deployment**

```
kubectl apply -f name.yaml
```

**Get pods**

```
kubectl get pods
```

![Alt text](pics/pods.png)

**See all details**

```
kubectl get all
```

![Alt text](pics/all.png)

s
