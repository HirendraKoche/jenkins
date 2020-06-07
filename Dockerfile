#################################################################
# Docker file for jenkins.
#
# Jenkins version :  2.222.3 stable release
# Jenkins runs on port : 8081
#
# Author : Hirendra Koche
##################################################################


FROM centos:7

LABEL maintainer="hirendrakoche1@outlook.com"

EXPOSE 8080

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG jenkins_url=http://mirror.serverion.com/jenkins/war-stable
ARG jenkins_version=2.222.3

ENV JENKINS_HOME=/var/jenkins_home JENKINS_VERSION=${jenkins_version}

WORKDIR ${JENKINS_HOME}

RUN set -eux && \
    groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} ${user}&& \
    mkdir /home/${user}/.ssh && \
    chmod 700 /home/${user}/.ssh; \
    yum install -y java-1.8.0-openjdk-devel python3 git openssh-clients && \
    curl -s -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py  && \
    pip3 install ansible --upgrade; \
    curl -s ${jenkins_url}/${JENKINS_VERSION}/jenkins.war -o /home/${user}/jenkins.war ;\
    chown -R ${user}:${group} ${JENKINS_HOME};

COPY entrypoint.sh /home/${user}/entrypoint.sh
COPY remote_key /home/${user}/.ssh/id_rsa

RUN chmod +x /home/${user}/entrypoint.sh; \
    chmod 600 /home/${user}/.ssh/id_rsa && \
    chown -R ${user}:${user} /home/${user}/.ssh

USER ${user}

VOLUME [ "${JENKINS_HOME}" ]

#ENTRYPOINT [ "java", "-jar", "jenkins.war", "--httpPort=8080"]
ENTRYPOINT $HOME/entrypoint.sh 