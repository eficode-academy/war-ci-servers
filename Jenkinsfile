pipeline {
  agent any
    environment {
        docker_username = 'praqmasofus'
  }
  options {
    skipDefaultCheckout(true)
  }
  stages {
    stage('Clone down') {
      steps {
        checkout scm
        stash(excludes: '.git', name: 'code')
        deleteDir()
      }
    }
    stage('Test and build') {
      parallel {
        stage('Test app') {
          steps {
            unstash 'code'
            sh 'bash ci/unit-test-app.sh'
            stash(excludes: '.git', name: 'code')
          }
        }
        stage('Build app') {
          steps {
            unstash 'code'
            sh 'bash ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash(excludes: '.git', name: 'code')
          }
        }
      }
    }
    stage('Build docker') {
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
    stage('System test') {
      steps {
        unstash 'code'
        sh 'bash ci/component-test.sh'
        sh 'bash ci/performance-test.sh'
      }
    }
  }
}
