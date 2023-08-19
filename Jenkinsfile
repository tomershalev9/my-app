pipeline {
    agent {
        kubernetes {
            defaultContainer 'dind-container'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  name: dind-test-pod
spec:
  containers:
    - name: dind-container
      image: tomershalev9/myapp:mydind
      securityContext:
        privileged: true
"""
        }
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Pull Files from GitHub') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        

        stage('Configure Docker Context') {
            steps {
                script {
                    sh '/usr/local/bin/docker context create ecs ecscontext --from-env'
                    sh 'docker context use ecscontext'
                }
            }
        }

        stage('Run Containers with Docker Compose') {
            steps {
                script {
                    sh 'docker-compose up'
                }
            }
        }
        
    }
}
