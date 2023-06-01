pipeline {

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    agent any

    tools {
        maven 'maven'
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'code compilation is starting'
                sh 'mvn clean compile'
				echo 'code compilation is completed'
            }
        }
        stage('Sonarqube Code Quality Check') {
            environment {
                scannerHome = tool 'qube'
            }
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                    sh 'mvn sonar:sonar'
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Code Package') {
            steps {
                echo 'code packing is starting'
                sh 'mvn clean package'
				echo 'code packing is completed'
            }
        }
        stage('Building & Tag Docker Image') {
             steps {
                echo 'Starting Building Docker Image'
                sh 'docker build -t kusumwakare/bookstore-ms .'
                sh 'docker build -t bookstore-ms .'
                echo 'Completed  Building Docker Image'
             }
        }
        stage('Docker Image Scanning') {
            steps {
                echo 'Docker Image Scanning Started'
                sh 'java -version'
                echo 'Docker Image Scanning Started'
            }
        }
        stage(' Docker push to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubCred', variable: 'dockerhubCred')]){
                        sh 'docker login docker.io -u kusumwakare -p ${dockerhubCred}'
                        echo "Push Docker Image to DockerHub : In Progress"
                        sh 'docker push kusumwakare/bookstore-ms:latest'
                        echo "Push Docker Image to DockerHub : In Progress"
                        sh 'whoami'
                    }
                }
            }
        }
        stage(' Docker Image Push to Amazon ECR') {
            steps {
               script {
                   docker.withRegistry('https://701158536369.dkr.ecr.ap-south-1.amazonaws.com/bookstore-ms', 'ecr:ap-south-1:ecr-cred'){
                   sh """
                   echo "List the docker images present in local"
                   docker images
                   echo "Tagging the Docker Image: In Progress"
                   docker tag bookstore-ms:latest 701158536369.dkr.ecr.ap-south-1.amazonaws.com/bookstore-ms:latest
                   echo "Tagging the Docker Image: Completed"
                   echo "Push Docker Image to ECR : In Progress"
                   docker push 701158536369.dkr.ecr.ap-south-1.amazonaws.com/bookstore-ms:latest
                   echo "Push Docker Image to ECR : Completed"
                   """
                   }
               }
            }
        }
        /*stage('Upload Docker Images to Nexus') {
            steps {
                script {
                    withCredentials{[usernamePassword(credentialsId: 'nexus-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]} {
                    sh 'docker login http://13.232.214.20:8085/repository/bookstore-ms-repo/ -u admin -p $(PASSWORD)'
                    echo "Push Docker Image to Nexus : In Progress"
                    sh 'docker tag bookstore-ms 13.232.214.20:8085/bookstore-ms:latest'
                    sh 'docker push 13.232.214.20:8085/bookstore-ms'
                    echo "Push Docker Image to Nexus : Completed"                              }
                }
            }
        }*/

        stage('Removing images from jenkins') {
              steps {
                 // Remove the Docker image from Jenkins
                 //sh 'docker images prune -a'
                 docker rm $(docker ps -a -f status=exited -q)
                 docker rm $(docker ps -a -f status=created -q)
                 docker rmi $(docker images -a)
              }
        }
    }
}
