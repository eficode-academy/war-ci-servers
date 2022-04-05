pipeline {
  agent any
  environment { 
        docker_username = 'praqmasofus'
  }
  stages {
    stage('clone down') {
      steps {
        stash(excludes: '.git', name: 'code')
        deleteDir()
      }
    }

    stage('Test and build') {
      parallel {
        stage('test app') {
          options {
            skipDefaultCheckout(true)
          }
          steps {
            unstash 'code'
            sh 'bash ci/unit-test-app.sh'
            stash(excludes: '.git', name: 'code')
          }
        }
        stage('build app') {
          options {
            skipDefaultCheckout(true)
          }
          steps {
            unstash 'code'
            sh 'bash ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash(excludes: '.git', name: 'code')
          }
        }
      }
    }
    stage('build docker') {
      options {
        skipDefaultCheckout(true)
      }
      environment {
                DCREDS = credentials('docker')
            }
      steps {
        unstash 'code'
        sh 'bash ci/lint-dockerfile.sh'
        sh 'echo "$DCREDS_PSW" | docker login -u "$DCREDS_USR" --password-stdin'
        sh 'bash ci/build-docker.sh'
        sh 'bash ci/push-docker.sh'
      }
    }
    stage('component test') {
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'bash ci/component-test.sh'
        sh 'bash ci/performance-test.sh'
      }
    }

  }
  
}