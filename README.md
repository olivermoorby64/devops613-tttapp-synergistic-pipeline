# Synergistic Pipeline #

- [Synergistic Pipeline](#synergistic-pipeline)
  - [The Plan](#the-plan)
    - [GitHub](#github)
    - [Jenkins](#jenkins)
    - [AWS](#aws)
  - [VM Setup](#vm-setup)
  - [Repo Structure](#repo-structure)
    - [The App](#the-app)
    - [The Jenkinsfile](#the-jenkinsfile)
    - [The Dockerfile](#the-dockerfile)
    - [Documents ###](#documents-)
  - [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
    - [Installing Docker](#installing-docker)
    - [Establishing The Pipeline](#establishing-the-pipeline)

## The Plan ##

### GitHub ###

Code changes will be sent to GitHub as version control.

### Jenkins ###

Code changes on GitHub will prompt a CI/CD pipeline from Jenkins. It will attempt to build and test the app, merging with main if successful, and then containerise the app (**this** bit will be tricky).

### AWS ###

An AWS EC2 instance will host the cluster containing the containerised version of the app. The instance will then deploy that container.

## VM Setup ##

Create EC2 instance using t3.small, the micro doesn't have enough RAM. Additionally, provide extra disk space, ~20GB.

Run some commands to update and install packages:

```bash
# Basic updates and installs
sudo apt update
sudo apt -y upgrade
sudo apt install -y curl git nginx

# Install docker and configure permissions
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Install Kubernetes
sudo snap install kubectl --classic

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker

# Configure Minikube
sudo nano /etc/systemd/system/minikube.service

sudo systemctl daemon-reload
sudo systemctl enable minikube.service

# Configure NginX
sudo rm /etc/nginx/sites-enabled/default
sudo nano /etc/nginx/sites-available/minikube
sudo ln -s /etc/nginx/sites-available/minikube /etc/nginx/sites-enabled/minikube
sudo systemctl reload nginx
```

## Repo Structure ##

### The App ###

All files related the the TicTacToe App itself will be placed under the `app` folder. This gives Docker a single target to containerise.

### The Jenkinsfile ###

A `Jenkinsfile` was added to the GitHub repo which checks out the code. It then attempts to containerise the app and upload the new version to DockerHub.

### The Dockerfile ###

The `Dockerfile` specifies how the app should be containerised. While the `Jenkinsfile` executes the command, that command will use the `Dockerfile` to configure the newly built image, such as what ports to expose and what commands to run when the image is booted.

### Documents ### ###

A spare folder for holding other relevant files, such as Nginx or Minikube files for the VM will be kept here. These files are totally unnecessary for the project to function but it's useful for organisational and debugging purposes.

## Jenkins CI/CD Pipeline ##

The CI/CD pipeline needs to trigger when a push on main is done. It will then containerise the app, upload the new version to DockerHub. The AWS instance then needs to download the new container version.

### Installing Docker ###

Before proceeding, the `Jenkinsfile` in the repository needs to be able to run Docker commands. This is done by creating a new Jenkins image which has Docker installed. So, such an image is created using the `Dockerfile` found within `docs`.

The Jenkins container is then started with this command in order to set up ports and allow Docker permissions:

```bash
docker run -d --name jenkins_with_docker --user root -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins-with-docker
```

### Establishing The Pipeline ###

In Jenkins, the pipeline is set to trigger manually or whenever a push to main is performed. The pipeline is set to execute the `Jenkinsfile` in the repository, which can be found [here](Jenkinsfile).

The file firstly disables the automatic checkout, this will be explained momentarily. Next, it cleans the workspace in case it contains an older version of the downloaded repo.

After that, it downloads the current version of the repo into the runner's working space. After that happened, the agent then runs a `docker build` command.

