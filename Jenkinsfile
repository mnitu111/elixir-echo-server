#!groovy

node {
  currentBuild.result = "SUCCESS"
  try {
    stage('Checkout') {
      checkout scm
    }

    stage('Build Docker') {
      docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
        def customImage = docker.build("scretu/elixir-echo-server:${env.BUILD_ID}")
        customImage.push()
      }
    }

    stage('Stage') {
      try {
        //label 'stage'
        sh """
          ssh docker@${STAGE_SWARM_MANAGER} "docker service create \
          --name=ees \
          --publish=6000:6000 \
          scretu/elixir-echo-server:${env.BUILD_ID}"
          """
      }
      catch (error) {
        print error
        sh """
          ssh docker@${STAGE_SWARM_MANAGER} "docker service update \
          --image scretu/elixir-echo-server:${env.BUILD_ID} \
          ees"
          """
      }
    }

    stage('Production') {
      node {
        //label 'prod'
        // try {
        //   sh """
        //     ssh docker@${PROD_SWARM_MANAGER} "docker service create \
        //     --name=ees \
        //     --publish=6000:6000 \
        //     scretu/elixir-echo-server:${env.BUILD_ID}"
        //     """
        //   }
        // }
        // catch () {
        //
        // }
    }
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
