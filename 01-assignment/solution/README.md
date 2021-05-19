# Solution - Assignment-1 - Docker, Jenkins

- ##### Task 1
  [Python base application code](task1/)
  ```
  # to run on local
  pip install -r requirements.txt
  python app.py
  ```

- ##### Task 2
  Install Docker in Linux Box
  ```
  # using ubuntu https://docs.docker.com/engine/install/ubuntu/
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  ```

  ```
  # create the docker group
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
  ```

  Run Jenkins container
  ```
  docker run -d -v jenkins_home:/var/jenkins_home --name jenkins-server -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk11
  ```

  Install suggested plugins, setup usrname and password<br />
  In jenkins UI create new jenkins agent with label 'docker-agent' jnlp and get jnlp secret<br />
  Run jenkins-agent as container from custom agent image
  ```
  docker build https://raw.githubusercontent.com/patelmanjeet/devops_assignment_collection/main/01-assignment/solution/jenkins-agent/Dockerfile -t jenkins/inbound-agent-docker
  sudo chmod 666 /var/run/docker.sock
  docker run -v /var/run/docker.sock:/var/run/docker.sock -d --init jenkins/inbound-agent-docker -url http://vm-ip:8080 <jnlp_secret> docker-agent
  ```

  Create Jenkins code-as-pipeline that will create docker image of World Clock API code<br />
  [Jenkins Pipeline](task1/Jenkinsfile) - In Jenkins create pipline type job for this Jenkinsfile

- ##### Task 3
  Run container on linux box for newly created image
  ```
  docker run -d --name app worldclock-app:latest
  ```

