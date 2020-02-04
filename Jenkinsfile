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
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
            stash(excludes: '.git', name: 'code')
          }
        }
        stage('build app') {
          options {
            skipDefaultCheckout(true)
          }
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
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
      steps {
        unstash 'code'
        sh 'ci/build-docker.sh'
      }
    }
    stage('push docker') {
      when { branch 'master' }
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'ci/push-docker.sh'
      }
    }
    stage('component test') {
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'ci/component-test.sh'
      }
    }

  }
  
}