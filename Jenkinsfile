pipeline {
    agent any
    stages {

        stage('Clone Repo') {
          steps {
            sh 'rm -rf packer-terraform-jenkins-docker'
            sh 'git clone git@github.com:mavrick202/packer-terraform-jenkins-docker.git'
            }
        }
		
				
      stage('Deploy EC2 Server') {
          steps {
		    sh 'terraform init'
            sh 'terraform apply --auto-approve'
            }
        }

        stage('Build Docker Image') {
          steps {
            sh 'cd /var/lib/jenkins/workspace/pipeline2/packer-terraform-jenkins-docker'
            sh 'cp  /var/lib/jenkins/workspace/pipeline2/packer-terraform-jenkins-docker/* /var/lib/jenkins/workspace/pipeline2'
            sh 'docker build -t sreeharshav/pipelinetestprod:${BUILD_NUMBER} .'
            }
        }

        stage('Push Image to Docker Hub') {
          steps {
           sh    'docker push sreeharshav/pipelinetestprod:${BUILD_NUMBER}'
           }
        }

        stage('Deploy to Docker Host') {
          steps {
		    sh 'sleep 10s'
            sh    'docker -H tcp://10.1.1.111:2375 stop prodwebapp1 || true'
            sh    'docker -H tcp://10.1.1.111:2375 run --rm -dit --name prodwebapp1 --hostname prodwebapp1 -p 8000:80 sreeharshav/pipelinetestprod:${BUILD_NUMBER}'
            }
        }

        stage('Check WebApp Rechability') {
          steps {
          sh 'sleep 10s'
          sh ' curl http://10.1.1.111:8000'
          }
        }
	  
        stage('Slack Message') {
            steps {
                slackSend channel: '#app2-dev-team',
                    color: 'good',
                    message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}"
            
            }
        }
    }
}
