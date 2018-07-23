#!groovy

node {
  currentBuild.result = "SUCCESS"
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Build Docker') {
      docker.withRegistry('https://hub.docker.com/', 'dockerhub')
        def customImage = docker.build("scretu/elixir-echo-server:${env.BUILD_ID}")
        customImage.push()
      }
    }
    //    stage('Deploy'){
    //
    //      echo 'Push to Repo'
    //      sh './dockerPushToRepo.sh'
    //
    //      echo 'ssh to web server and tell it to pull new image'
    //      sh 'ssh deploy@xxxxx.xxxxx.com running/xxxxxxx/dockerRun.sh'
    //    }
    //    stage('Cleanup'){
    //      echo 'prune and cleanup'
    //      sh 'npm prune'
    //      sh 'rm node_modules -rf'
    //
    //      mail body: 'project build successful',
    //                  from: 'xxxx@yyyyy.com',
    //                  replyTo: 'xxxx@yyyy.com',
    //                  subject: 'project build successful',
    //                  to: 'yyyyy@yyyy.com'
    //    }

  }
    catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}
