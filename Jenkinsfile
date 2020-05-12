pipeline {
  agent any
  
  environment {
    IMAGE_NAME = "customLinux-${BUILD_NUMBER}"
    VERSION = "0.0.4"
    }

        "activation_id": "",
    "customer_id": ""
  
  stages {
    stage('Create Packer AMI') {
        steps {
    withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59'),
    usernamePassword(credentialsId: 'qualysid', usernameVariable: 'AT_ID', passwordVariable: 'CU_ID')]) {
            sh '''
              /usr/local/bin/packer build -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID -var ami_name=${IMAGE_NAME} -var activation_id=$AT_ID -var customer_id=$CU_ID packer/packer.json
            '''
        }
      }
    }
    stage('Azure Deployment') {
      steps {
           withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
            {
            sh '''
               cd terraform
               terraform init
               terraform apply -auto-approve -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID  -var ami_name=${IMAGE_NAME} 
            '''
        }
      }
    }
    stage('Upload to SIG') {
      steps {
          withCredentials ([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
               {
            sh '''
                export AZURE_CLIENT_ID=$AZURE_CLIENT_ID
                export AZURE_SECRET=$AZURE_CLIENT_SECRET
                export AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                export AZURE_TENANT=$AZURE_TENANT_ID
                export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook ansible/sig.yml -e '{"shared_image_name":"env.IMAGE_NAME", "shared_image_version":"env.VERSION"}'

            '''
        }
      }
    }

  }
}
