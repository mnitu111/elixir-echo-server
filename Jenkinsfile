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
          ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/id_rsa docker@${STAGE_SWARM_MANAGER} \
          "docker service create \
          --name=ees \
          --publish=6000:6000 \
          scretu/elixir-echo-server:${env.BUILD_ID}"
          """
      }
      catch (Exception e) {
        print e
        sh """
          ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/id_rsa docker@${STAGE_SWARM_MANAGER} \
          "docker service update \
          --image scretu/elixir-echo-server:${env.BUILD_ID} \
          ees"
          """
      }
    }

    stage('Smoke Test Stage') {
      def testImage = docker.build("elixir-echo-server-test:${env.BUILD_ID}", "-f test-Dockerfile ./")
      def output = sh """
        docker run -e HOST='${STAGE_SWARM_MANAGER}' --rm --name test elixir-echo-server-test:${env.BUILD_ID}
        """
      print output
    }

    stage('Production') {
      node {
        //label 'prod'
        timeout(time: 1, unit: 'HOURS') {
          input(message: 'Shall we deploy to Production?', submitter: 'admin')
        }
        try {
          sh """
            ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/id_rsa docker@${PROD_SWARM_MANAGER} \
            "docker service create \
            --name=ees \
            --publish=6000:6000 \
            scretu/elixir-echo-server:${env.BUILD_ID}"
            """
        }
        catch (Exception e) {
          print e
          sh """
            ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/id_rsa docker@${PROD_SWARM_MANAGER} \
            "docker service update \
            --image scretu/elixir-echo-server:${env.BUILD_ID} \
            ees"
            """
        }
      }
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
