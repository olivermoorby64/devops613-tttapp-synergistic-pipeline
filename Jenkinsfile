pipeline {

    agent any

    // Stop the automatic checkout
    options {
        skipDefaultCheckout(true)
    }

    stages {

        // When dealing with repos, always delete the stored old one first
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        // Get new code from the updated repository
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // Update the Docker image of the app using the Dockerfile
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sparta-tttapp .'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sparta-tttapp .'
            }
        }

        stage('Publish Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) 
                {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

                        docker tag sparta-tttapp "$DOCKER_USERNAME/sparta-tttapp:latest"

                        docker push "$DOCKER_USERNAME/sparta-tttapp:latest"

                        docker logout
                    '''
                }
            }
        }

    }
}