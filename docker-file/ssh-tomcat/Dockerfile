#VERSIION 0.0.1
FROM ubuntu:12.04
MAINTAINER ycliu912 "ycliu1283@gmail.com"

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe"> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

RUN echo "root:root" | chpasswd

RUN apt-get install python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -y vim wget curl oracle-java7-installer tomcat7

RUN update-alternatives --display java
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle">> /etc/environment
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle">> /etc/default/tomcat7


EXPOSE 22
EXPOSE 8080

ENTRYPOINT service tomcat start && /usr/sbin/sshd -D
