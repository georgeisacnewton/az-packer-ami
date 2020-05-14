pipeline {
  agent any
  
  environment {
    IMAGE_NAME = "customLinux-41"
    VERSION = "0.0.4"
    }
    
  stages {
    // stage('Create Packer AMI') {
    //     steps {
    // withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59'),
    // usernamePassword(credentialsId: 'qualysid', usernameVariable: 'AT_ID', passwordVariable: 'CU_ID')]) {
    //         sh '''
    //           /usr/local/bin/packer build -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID -var ami_name=${IMAGE_NAME} -var activation_id=$AT_ID -var customer_id=$CU_ID packer/packer.json
    //         '''
    //     }
    //   }
    // }
    // stage('Azure Deployment') {
    //   steps {
    //        withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
    //         {
    //         sh '''
    //         az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
    //         az vm create --resource-group testrg  --name ${IMAGE_NAME} --image ${IMAGE_NAME} --admin-username azureuser --ssh-key-values "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvZq7Y2gWeXuD/xxzlo5lYXw5ZMhlusqg/5F3K1KvW7cHi9sXOf76QI0jAKijaFqMcMyNpjaMuEOMSgA+MoxPh9CSkfVgGt3toBvwVEs/7fFif7dL6LuWi+52Pmizh7nUg3dRbuWPjmT9jlnnmV4A4A8K/FN/Zjb5lQofsM/fRY+nGq/UFU+bJu/ti5V15ExJoB9cK3cvDComD0W+MIWBWttrCF2DsEF2TB2Ymex4c2iF/ebVTgoxpFyCkjVPEc58/q8lvoLyiN7CovKf7ThjOMrDVxTl+6cCWfP2WHP8634wvQ6ChWFHOtvl7EduPOrU121fhRqyUvNnJxcRAKt/"
    //         '''
    //     }
    //   }
    // }

    stage('Condition') {
      steps {
  
                script {
                    env.RELEASE_SCOPE = input message: 'User input required', ok: 'Release!',
                            parameters: [choice(name: 'RELEASE_SCOPE', choices: 'Yes\nNo', description: 'What is the release scope?')]
                }
                echo "${env.RELEASE_SCOPE}"
    
    }
    }
      // stage('Delete VM') { 

      //   when {
      //      expression { 
      //        environment name: 'RELEASE_SCOPE', value: 'No' 
      //         }
      //   }
      //   steps {

      //      echo "Hello ${env.RELEASE_SCOPE} "

      //        withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
      //       {
      //       sh '''
      //       az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
      //       az vm delete -g testrg -n ${IMAGE_NAME} --yes
      //       '''
      //       }
      // }
      // }
      
     stage('Delete VM') { 

      steps {
      script {
            if("${env.RELEASE_SCOPE}" == 'Yes') {
            echo "Hello ${env.RELEASE_SCOPE} "
            
            withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
            {
            sh '''
            az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
            az vm delete -g testrg -n ${IMAGE_NAME} --yes
            '''
            }

            }
        }
      }
     }
    
    stage('Upload to SIG') {
    
      when {
           expression { 
          "${env.RELEASE_SCOPE}" == 'No'
           }
        
        }
      steps{  
        echo "Hello ${env.RELEASE_SCOPE}"
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




 