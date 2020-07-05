// Declarative pipeline syntax (opinionated / easier to learn and use)
// https://jenkins.io/doc/book/pipeline/syntax/#compare
pipeline {

  agent {
    kubernetes {
      containerTemplate {
        name 'builder'
        // Pin image tag to avoid breaking changes
        image '<PRIVATE_DOCKER_REPO>/golden-images/build-container:10'
        ttyEnabled true
        command 'cat'
      }
    }
  }

  environment {
    CI_DEBUG_ENABLED = "true"
    // https://www.packer.io/docs/other/debugging.html#debugging-packer
    PACKER_ON_ERROR_ACTION = "ask"
    PACKER_LOG = 1
    PACKER_COLOR_OUTPUT_ENABLED = "true"
    PACKER_CONFIG_PATH = "./packer/ubuntu-ansible.json"
  }

  libraries {
    // Ensure the branch name is updated during development, then return to "master" once build is stable
    lib('MyLibraries@master')
  }

  // declare options once, rather than repeating in multiple stages
  options {
    ansiColor('xterm')
    withCredentials([
      // set env vars for Packer
      azureServicePrincipal(credentialsId: 'pipeline', clientIdVariable: 'ARM_CLIENT_ID', clientSecretVariable: 'ARM_CLIENT_SECRET', subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID', tenantIdVariable: 'ARM_TENANT_ID')
    ])
  }

  stages {
    stage('Build Packer') {
      steps {
        sh label: 'Set script permissions', script: 'chmod -R +x ./scripts/'
        sh label: 'Init', script: './scripts/init.sh'
        sh label: 'Build Packer', script: './scripts/build_packer.sh'
      }
    }
  }
}
