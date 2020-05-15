pipeline {
  agent any
  
  environment {
    IMAGE_NAME = "customLinux-120"
    VERSION = "0.0.4"
    RG = "testrg"
    SIG= "SIG_test"
    }
    
  stages {
  //   stage('Create Packer AMI') {
  //       steps {
  //   withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59'),
  //   usernamePassword(credentialsId: 'qualysid', usernameVariable: 'AT_ID', passwordVariable: 'CU_ID')]) {
  //           sh '''
  //             /usr/local/bin/packer build -var client_id=$AZURE_CLIENT_ID -var client_secret=$AZURE_CLIENT_SECRET  -var tenant_id=$AZURE_TENANT_ID -var ami_name=${IMAGE_NAME} -var activation_id=$AT_ID -var customer_id=$CU_ID packer/packer.json
  //           '''
  //       }
  //     }
  //   }
    // stage('Azure VM Scan') {
    //   steps {
    //        withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59'),
    //        usernamePassword(credentialsId: 'qualysid', usernameVariable: 'AT_ID', passwordVariable: 'CU_ID')])
    //         {
    //         sh '''
    //         az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
    //         az vm create --resource-group testrg  --name ${IMAGE_NAME} --image ${IMAGE_NAME} --admin-username azureuser --ssh-key-values "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvZq7Y2gWeXuD/xxzlo5lYXw5ZMhlusqg/5F3K1KvW7cHi9sXOf76QI0jAKijaFqMcMyNpjaMuEOMSgA+MoxPh9CSkfVgGt3toBvwVEs/7fFif7dL6LuWi+52Pmizh7nUg3dRbuWPjmT9jlnnmV4A4A8K/FN/Zjb5lQofsM/fRY+nGq/UFU+bJu/ti5V15ExJoB9cK3cvDComD0W+MIWBWttrCF2DsEF2TB2Ymex4c2iF/ebVTgoxpFyCkjVPEc58/q8lvoLyiN7CovKf7ThjOMrDVxTl+6cCWfP2WHP8634wvQ6ChWFHOtvl7EduPOrU121fhRqyUvNnJxcRAKt/"
    //         az vm run-command invoke -g testrg -n ${IMAGE_NAME}  --command-id RunShellScript --scripts '/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=$1 CustomerId=$2' --parameters $AT_ID $CU_ID
    //         '''
    //     }
    //   }
    // }

    stage('Condition') {
      steps {
  
                script {
                    env.ACTION = input message: 'User input required', ok: 'Release!',
                            parameters: [choice(name: 'ACTION', choices: 'Yes\nNo', description: 'Proceed ?')]
                }
                echo "${env.ACTION}"
    
    }
    }
      stage('Destory VM') { 

        when {
           expression { 
             "${env.ACTION}" == 'No'
              }
        }
        steps {

           echo "Hello ${env.ACTION} "

             withCredentials([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
            {
            sh '''
            az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
            az vm delete -g testrg -n ${IMAGE_NAME} --yes
            az image delete -n ${IMAGE_NAME} -g ${RG}
            '''
            }
      }
      }

       stage('Delete VM and share GM') {
    
        when {
           expression { 
          "${env.ACTION}" == 'Yes'
           }
        
         }
        steps{  
         echo "Hello ${env.ACTION}"
          withCredentials ([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
                {
            sh '''
                az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
                az vm delete -g testrg -n ${IMAGE_NAME} --yes
                az sig create --resource-group ${RG} --gallery-name ${SIG}
                sigId=$(az sig show --resource-group ${RG} --gallery-name ${SIG} --query id --output tsv)
                az sig image-definition create --resource-group ${RG} --gallery-name ${SIG} --gallery-image-definition packercentos --publisher Cloudsec --offer centoscloudsec --sku 7 --os-type linux --os-state generalized
                az role assignment create --role "Reader" --assignee georgeisacnewton@gmail.com --scope $sigId
                az image update -n ${IMAGE_NAME} -g ${RG} --tags tag1=GM tag2=centos7
                imageID="/subscriptions/86d22e9c-bc56-49c3-a93a-0586bbb4ee79/resourceGroups/testrg/providers/Microsoft.Compute/images/${IMAGE_NAME}"
                az sig image-version create --resource-group ${RG} --gallery-name ${SIG} --gallery-image-definition packercentos --gallery-image-version 1.0.0 --target-regions "southcentralus=1" "eastus2=1=Standard_LRS" --replica-count 2 --managed-image $imageID
            '''
         }
        }
      }
    //  stage('Upload to SIG') {
    
    //   when {
    //        expression { 
    //       "${env.ACTION}" == 'Yes'
    //        }
        
    //     }
    //   steps{  
    //     echo "Hello ${env.ACTION}"
    //     withCredentials ([azureServicePrincipal('6733829c-3f4f-49c5-a2f8-536f17e2cf59')])
    //            {
    //         sh '''
    //             az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET  --tenant $AZURE_TENANT_ID
    //             az vm delete -g testrg -n ${IMAGE_NAME} --yes
    //             // export AZURE_CLIENT_ID=$AZURE_CLIENT_ID
    //             // export AZURE_SECRET=$AZURE_CLIENT_SECRET
    //             // export AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
    //             // export AZURE_TENANT=$AZURE_TENANT_ID
    //             // export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook ansible/sig.yml -e '{"shared_image_name":"env.IMAGE_NAME", "shared_image_version":"env.VERSION"}'

    //         '''
    //      }
    //     }
    //   }
      }
    }




 