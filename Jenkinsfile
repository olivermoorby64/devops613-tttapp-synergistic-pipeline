pipeline {

    agent any

    stages {

        // Get new code from updated repository
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // Update Docker image of the app using the Dockerfile
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t sparta-tttapp .'
            }
        }

    }
}