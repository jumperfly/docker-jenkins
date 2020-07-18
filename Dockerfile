FROM jenkins/jenkins:2.235.2-lts

USER root
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - &&\
  echo 'deb [arch=amd64] https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  apt-get -y install docker-ce-cli=5:19.03.12~3-0~debian-stretch &&\
  rm -rf /var/lib/apt/lists/*
USER jenkins

COPY plugins.txt /usr/share/jenkins/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

ENV \
  SECRETS=/etc/jenkins/casc/secrets.properties \
  CASC_JENKINS_CONFIG=/etc/jenkins/casc \
  JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
  JENKINS_NUM_EXECUTORS=0 \
  JENKINS_URL=http://jenkins:8080 \
  JENKINS_ADMIN_ADDRESS="Jenkins <jenkins@localhost>"

COPY casc/ /etc/jenkins/casc/

USER root
RUN chown jenkins:jenkins /etc/jenkins/casc/secrets.properties &&\
  chmod 600 /etc/jenkins/casc/secrets.properties
USER jenkins
