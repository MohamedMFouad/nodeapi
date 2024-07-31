pipeline {
    agent any

    environment {
        REGISTRY = "your-docker-registry" // e.g., your Docker Hub username or registry URL
        IMAGE_NAME = "nodejs-api-template"
        REGISTRY_CREDENTIALS = 'docker-hub-credentials' // Jenkins credential ID for Docker registry
        AZURE_CREDENTIALS = 'azure-credentials' // Jenkins credential ID for Azure
        RESOURCE_GROUP = 'your-azure-resource-group'
        AKS_CLUSTER = 'your-aks-cluster'
        NAMESPACE = 'default' // Kubernetes namespace
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/amarthakur0/nodejs-api-template']]])
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', "${REGISTRY_CREDENTIALS}") {
                        sh "docker push ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Deploy to Azure AKS') {
            steps {
                script {
                    withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS)]) {
                        sh '''
                        az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER}
                        kubectl set image deployment/${IMAGE_NAME} ${IMAGE_NAME}=${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} -n ${NAMESPACE}
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
