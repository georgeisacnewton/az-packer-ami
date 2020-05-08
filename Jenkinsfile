pipeline {
  agent any
  
  environment {
    IMAGE_NAME = "customLinux-6"
    version = "0.0.1"
    }
  
  stages {
    // stage('Create Packer AMI') {
    //     steps {
    // withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')]) {
    //         sh '''
    //           /usr/local/bin/packer build -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID -var ami_name=${IMAGE_NAME} packer/packer.json
    //         '''
    //     }
    //   }
    // }
    // stage('Azure Deployment') {
    //   steps {
    //       withCredentials([
    //         usernamePassword(credentialsId: '28519c1b-4036-4fc1-961f-f92cf70853e7', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')
    //         // usernamePassword(credentialsId: '2facaea2-613b-4f34-9fb7-1dc2daf25c45', passwordVariable: 'REPO_PASS', usernameVariable: 'REPO_USER'),
    //       ]) {
    //         sh '''
    //            cd terraform
    //            terraform init
    //            terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET} -var ami_name=${IMAGE_NAME}
    //         '''
    //     }
    //   }
    // }
    stage('Upload to SIG') {
      steps {
          withCredentials ([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
               {
            sh '''
                export AZURE_CLIENT_ID=$AZURE_CLIENT_ID
                export AZURE_SECRET=$AZURE_CLIENT_SECRET
                export AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                export AZURE_TENANT=$AZURE_TENANT_ID
                export ansible_python_interpreter=/usr/bin/python2
                ansible-playbook ansible/sig.yml -e '{"shared_image_name":"${IMAGE_NAME}", "shared_image_version":"${version}"}'

            '''
        }
      }
    }

  }
}
