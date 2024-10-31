
pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = 'raksha0/node-js'
        DOCKER_HUB_CREDS = credentials('2f46fe2b-1fe8-47eb-9500-cf0383a3c54f')
        BLUE_CONTAINER = 'blue'
        GREEN_CONTAINER = 'green'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_REPO}:${env.BUILD_ID}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_HUB_CREDS) {
                        docker.image("${DOCKER_HUB_REPO}:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        stage('Deploy Blue-Green') {
            steps {
                script {
                    def activeContainer = sh(script: 'docker ps --filter name=${BLUE_CONTAINER} --format "{{.Names}}"', returnStdout: true).trim()
                    def targetContainer = activeContainer == BLUE_CONTAINER ? GREEN_CONTAINER : BLUE_CONTAINER
                    
                    // Stop and remove the inactive container if it's running
                    sh "docker rm -f ${targetContainer} || true"
                    
                    // Start the new version on the target container
                    sh "docker run -d --name ${targetContainer} -p 3000:3000 ${DOCKER_HUB_REPO}:${env.BUILD_ID}"
                    
                    // Optional health check before switching
                    sh "sleep 10"
                    
                    // Stop the old version
                    sh "docker rm -f ${activeContainer}"
                }
            }
        }
    }
    post {
        cleanup {
            // Clean up any dangling images after deployment
            sh "docker image prune -f"
        }
    }
}
