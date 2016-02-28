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

# Maven
ENV MAVEN_VERSION 3.3.3

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

COPY maven.sh /etc/profile.d/


RUN yum install -y epel-release && \
  yum install -y unzip \
  gcc openssl-devel python-devel python-setuptools libffi-devel \
  cyrus-sasl-md5 ncftp \
  ant ant-jsch \
  pyOpenSSL python2-crypto python-pip python-virtualenv \
  perl-DBD-mysql perl-JSON perl-XML-Twig \
  mariadb-libs mariadb mysql-connector-java \
  sudo which pwgen \
  subversion git-svn && \
  yum clean all -q

RUN yum install -y firefox xorg-x11-server-Xvfb ant-junit libexif && \
  yum install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
  dbus-uuidgen > /var/lib/dbus/machine-id && \
  yum clean all -q

# Install gcloud
ENV GCLOUD_VERSION 94.0.0

RUN curl -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GCLOUD_VERSION-linux-x86_64.tar.gz | tar -xzf - -C /opt \
  && chmod +x /opt/google-cloud-sdk/bin/* \
  && ln -s /opt/google-cloud-sdk/bin/* /usr/local/bin/

ENV JDK8_VERSION 8u71-b15

RUN cd /tmp &&\
  curl -sLO -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JDK8_VERSION}/jdk-${JDK8_VERSION%%-*}-linux-x64.rpm && \
  yum install -y /tmp/jdk-${JDK8_VERSION%%-*}-linux-x64.rpm && \
  rm -f /tmp/jdk-${JDK8_VERSION%%-*}-linux-x64.rpm && \
  yum clean all -q

COPY oracle-jdk.sh /etc/profile.d/


COPY docker-entrypoint-init.d /docker-entrypoint-init.d

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh


VOLUME "$JENKINS_HOME"

ENV SSHD_PORT 22
EXPOSE $SSHD_PORT

ENTRYPOINT ["/docker-entrypoint.sh"]
