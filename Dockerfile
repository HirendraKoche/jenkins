#################################################################
# Docker file for jenkins.
#
# Jenkins version :  2.222.3 stable release
# Jenkins runs on port : 8081
#
# Author : Hirendra Koche
##################################################################


FROM hirendrakoche/jre:8

LABEL maintainer="hirendrakoche1@outlook.com"

EXPOSE 8081

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG jenkins_url=http://mirror.serverion.com/jenkins/war-stable
ARG jenkins_version=2.222.3

ENV JENKINS_HOME=/var/jenkins_home JENKINS_VERSION=${jenkins_version}

WORKDIR ${JENKINS_HOME}

RUN set -eux; \
    groupadd -g ${gid} ${group}; \
    useradd -u ${uid} -g ${gid} ${user}; \
    curl -s ${jenkins_url}/${JENKINS_VERSION}/jenkins.war -o ${JENKINS_HOME}/jenkins.war ;\
    chown -R ${user}:${group} ${JENKINS_HOME};

USER ${user}

VOLUME [ "${JENKINS_HOME}" ]

ENTRYPOINT [ "java", "-jar", "jenkins.war", "--httpPort=8081"]
