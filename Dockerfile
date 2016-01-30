# Jenkins slave
#
#

FROM centos:latest
MAINTAINER Ruggero Marchei <ruggero.marchei@daemonzone.net>


RUN yum install -y java-1.8.0-openjdk-headless \
  openssh-server \
  unzip \
  git \
  && yum clean all -q


ENV JENKINS_HOME /var/jenkins

RUN groupadd -r jenkins --gid=994 \
  && useradd -d "$JENKINS_HOME" -m -s /bin/bash -r -g jenkins -G wheel --uid=994 jenkins

RUN sed -E -i "s/#?UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -E -i "s/#?PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
  && sed -E -i "s/#?UseDNS.*/UseDNS no/g" /etc/ssh/sshd_config \
  && sed -E -i "s/#?GSSAPIAuthentication.*/GSSAPIAuthentication no/g" /etc/ssh/sshd_config \
  && rm -f /etc/ssh/ssh_host_*_key*


RUN mkdir /docker-entrypoint-init.d
COPY docker-entrypoint-init.d/* /docker-entrypoint-init.d/

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh


VOLUME "$JENKINS_HOME"

ENV SSHD_PORT 22
EXPOSE $SSHD_PORT

ENTRYPOINT ["/docker-entrypoint.sh"]
