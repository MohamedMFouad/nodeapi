pipeline {
    agent any

    environment {
        NPM_CONFIG_PREFIX = "/var/jenkins_home/npm-global"
        PATH = "/var/jenkins_home/npm-global/bin:$PATH"
        DOCKER_IMAGE = "myregistry.azurecr.io/nodejs-api:${env.BUILD_NUMBER}"
        AZURE_CREDENTIALS = credentials('azure-credentials')
        ACR_CREDENTIALS = credentials('acr-credentials')
    }


    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/MohamedMFouad/nodeapi'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm install'
               
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('https://nodeapi.azurecr.io', 'acr-credentials') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

stage('Deploy to Azure') {
    steps {
        withCredentials([azureServicePrincipal(
            credentialsId: 'azure-credentials', 
            subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', 
            clientIdVariable: 'AZURE_CLIENT_ID', 
            clientSecretVariable: 'AZURE_CLIENT_SECRET', 
            tenantIdVariable: 'AZURE_TENANT_ID'
        ), usernamePassword(
            credentialsId: 'acr-credentials', 
            usernameVariable: 'AZURE_ACR_USERNAME', 
            passwordVariable: 'AZURE_ACR_PASSWORD'
        )]) {
            sh '''
            az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}
            
            az webapp config container set \
                --resource-group nodeapi_group  \
                --name nodeapi \
                --docker-custom-image-name myregistry.azurecr.io/nodejs-api \
                --docker-registry-server-url https://nodeapi.azurecr.io \
                --docker-registry-server-user ${AZURE_ACR_USERNAME} \
                --docker-registry-server-password ${AZURE_ACR_PASSWORD}
                
            # Restart the web app to apply changes
            az webapp restart --resource-group nodeapi_group --name nodeapi
            '''
        }
    }
}


    }
}
