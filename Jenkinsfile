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

    // stage('Condition') {
    //   steps {
    //      input {
    //             message "Should we continue?"
    //             submitter "Yes,No"
    //             parameters {
    //                 string(name: 'Action', defaultValue: 'No', description: '?')
    //             }
    //         }
    //   }
    //     }

      stage('Condition') {
        steps {
        script {
        // Show the select input modal
            def INPUT_PARAMS = input(id:'userinput' , message: 'Please Provide Parameters',
                        parameters: [
                        choice(name: 'ACTION', choices: ['Yes','No'].join('\n'), description: '')])

         if( "${INPUT_PARAMS}" == "Yes")
              {
             withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
            {
            sh '''
            az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
            az vm delete -g testrg -n ${IMAGE_NAME}--yes
            '''
            }
      }
      }
        }
      }

  
    stage('Upload to SIG') {
      steps{
      script {
        if( "${INPUT_PARAMS}" == "No") {
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

  }
}


 