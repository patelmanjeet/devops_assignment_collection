# Solution - Assignment-1 - Docker, Jenkins

- ##### Task 1
  [Python base application code](/task1)
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

  Run Jenkins & jenkins-agent as container
  >  </br>
  >

  Create Jenkins code-as-pipeline that will create docker image of World Clock API code
  >  </br>
  >


- ##### Task 3
  Run container on linux box for newly created image
  >
  >

