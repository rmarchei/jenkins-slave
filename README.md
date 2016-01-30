Jenkins Slave
=============

[![Build Status](https://travis-ci.org/rmarchei/jenkins-slave.svg?branch=master)](https://travis-ci.org/rmarchei/jenkins-slave)

Dockerfile to create a Jenkins slave based on CentOS 7


Usage examples:
- set root and jenkins users password using a clear text env variable:
```
docker run -d -P -e ROOT_PW='travis_test_password' -e JENKINS_PW='travis_test_password' rmarchei/jenkins-slave
```

- set jenkins user password using a SHA512 hash:
```
docker run -d -P -e JENKINS_PW='$6$bKgc8/JhVp7/DKZp$7yy32cznyJmlzgQl3rO7OtIhlWk/OkeRdUWtWiv.eYdQkjm1Z4UTrE8LG4IzcP49E2OTbODS.rMkkDxUevZnQ/' rmarchei/jenkins-slave
```

- change SSHD listening port to 24: 
```
docker run -d --net=host -e SSHD_PORT=24 -e JENKINS_PW='travis_test_password' rmarchei/jenkins-slave
```
