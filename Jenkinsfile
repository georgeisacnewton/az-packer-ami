pipeline {
  agent any
  
  environment {
    IMAGE_NAME = "customLinux-${BUILD_NUMBER}"
    }
  
  stages {
    stage('Create Packer AMI') {
        steps {
    withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')]) {
            sh '''
              /usr/local/bin/packer build -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID -var ami_name=${IMAGE_NAME} packer/packer.json
            '''
        }
      }
    }
    stage('Azure Deployment') {
      steps {
          withCredentials([
            usernamePassword(credentialsId: '28519c1b-4036-4fc1-961f-f92cf70853e7', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')
            // usernamePassword(credentialsId: '2facaea2-613b-4f34-9fb7-1dc2daf25c45', passwordVariable: 'REPO_PASS', usernameVariable: 'REPO_USER'),
          ]) {
            sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET} -var ami_name=${IMAGE_NAME}
            '''
        }
      }
    }
    stage('Upload to SIG') {
      steps {
          withCredentials ([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
               {
            sh '''

            '''
        }
      }
    }

  }
}
