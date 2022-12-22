pipeline {
    environment {
        ID_DOCKER = "julios2"
        IMAGE_NAME = "static_website"
        IMAGE_TAG = "latest"
        APP_NAME = "jules"
        STAGING = "juliosISTY-staging"
        PRODUCTION = "juliosISTY-production"
        API_ENDPOINT = "ip10-0-1-3-ceidnr0mjkegg872c1r0-1996.direct.docker.labs.eazytraining.fr"
        STG_APP_ENDPOINT = "ip10-0-1-3-ceidnr0mjkegg872c1r0-81.direct.docker.labs.eazytraining.fr"
        PROD_APP_ENDPOINT = "ip10-0-1-3-ceidnr0mjkegg872c1r0-80.direct.docker.labs.eazytraining.fr"
        INTERNAL_PORT = "3000"
        EXTERNAL_PORT = 80
        STG_EXTERNAL_PORT = 81
        PROD_EXTERNAL_PORT = 80
        CONTAINER_IMAGE = "${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}"
    }    
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }
        stage('Run container based on builded image') {
            agent any
            steps {
                script {
                    sh '''
                        echo "Clean Environment"
                        docker rm -f $IMAGE_NAME || echo "container does not exist"
                        docker run -d -p ${EXTERNAL_PORT}:${INTERNAL_PORT} --name $IMAGE_NAME ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                        sleep 5
                    '''
                    
                }
            }
        }
        stage('Test image') {
            agent any
            steps {
                script {
                    sh '''
                        curl 172.17.0.1 | grep -i "Dimension"
                    '''
                    
                }
            }
        }
        stage('Clean container') {
            agent any
            steps {
                script {
                    sh '''
                        docker stop $IMAGE_NAME
                        docker rm $IMAGE_NAME
                    '''
                    
                }
            }
        }
        stage('Save Artefact') {
            agent any
            steps {
                script {
                    sh '''
                        docker save  ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG > /tmp/${IMAGE_NAME}.tar                 
                    '''
                }
            }
        }          
          
        stage ('Login and Push Image on docker hub') {
              agent any
            environment {
               DOCKERHUB_PASSWORD  = credentials('dockerhub-pwd')
            }            
            steps {
                script {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
                        docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }         
        stage('Push image in staging and deploy it') {
            when {
                expression {GIT_BRANCH == 'origin/main'}
            }
            agent any

            steps {
                script {
                    sh """
                        echo  {\\"your_name\\":\\"${APP_NAME}\\",\\"container_image\\":\\"${CONTAINER_IMAGE}\\", \\"external_port\\":\\"${STG_EXTERNAL_PORT}\\", \\"internal_port\\":\\"${INTERNAL_PORT}\\"}  > data.json 
                        curl -X POST http://${API_ENDPOINT}/staging -H 'Content-Type: application/json'  --data-binary @data.json 
                    """
                    
                }
            }
        }
        stage('Push image in production and deploy it') {
            when {
                expression {GIT_BRANCH == 'origin/main'}
            }
            agent any

            steps {
                script {
                    sh """
                        curl -X POST http://${API_ENDPOINT}/prod -H 'Content-Type: application/json' -d '{"your_name":"${APP_NAME}","container_image":"${CONTAINER_IMAGE}", "external_port":"${PROD_EXTERNAL_PORT}", "internal_port":"${INTERNAL_PORT}"}'
                    """
                    
                }
            }
        }
    }
    post {
        success {
            slackSend (color: '#00FF00', message: "ULRICH - SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL}) - PROD URL => http://${PROD_APP_ENDPOINT} , STAGING URL => http://${STG_APP_ENDPOINT}")
        }
        failure {
            slackSend (color: '#FF0000', message: "ULRICH - FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }  
    }
}
