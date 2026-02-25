pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  triggers {
    githubPush()
  }

  parameters {
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region')
    string(name: 'TF_ENV', defaultValue: 'prod', description: 'Terraform environment directory under terraform/environments/')
    booleanParam(name: 'AUTO_APPLY', defaultValue: false, description: 'Auto apply terraform changes on main branch')
    string(name: 'SONAR_PROJECT_KEY', defaultValue: 'hospital-infrastructure', description: 'SonarQube project key')
    string(name: 'SONAR_PROJECT_NAME', defaultValue: 'hospital-infrastructure', description: 'SonarQube project name')
  }

  environment {
    TF_DIR = "terraform/environments/${params.TF_ENV}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p reports'
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('sonarqube') {
          sh '''
            sonar-scanner \
              -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
              -Dsonar.projectName=${SONAR_PROJECT_NAME} \
              -Dsonar.sources=terraform
          '''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: false
        }
      }
    }

    stage('Checkov') {
      steps {
        sh '''
          checkov -d terraform --framework terraform,secrets --quiet \
            | tee reports/checkov.txt
        '''
      }
    }

    stage('Trivy IaC Scan') {
      steps {
        sh '''
          trivy config terraform \
            --severity HIGH,CRITICAL \
            --exit-code 1 \
            --format table \
            --output reports/trivy-config.txt
        '''
      }
    }

    stage('Terraform Init') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-jenkins'
        ]]) {
          dir("${TF_DIR}") {
            sh 'terraform init -input=false'
          }
        }
      }
    }

    stage('Terraform Validate') {
      when {
        branch 'main'
      }
      steps {
        dir("${TF_DIR}") {
          sh 'terraform validate'
        }
      }
    }

    stage('Terraform Plan') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-jenkins'
        ]]) {
          dir("${TF_DIR}") {
            sh 'terraform plan -out=tfplan -input=false'
          }
        }
      }
    }

    stage('Terraform Apply') {
      when {
        allOf {
          branch 'main'
          expression { return params.AUTO_APPLY == true }
        }
      }
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-jenkins'
        ]]) {
          dir("${TF_DIR}") {
            sh 'terraform apply -input=false -auto-approve tfplan'
          }
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts allowEmptyArchive: true, artifacts: 'reports/*,terraform/environments/**/tfplan'
      cleanWs()
    }
  }
}
