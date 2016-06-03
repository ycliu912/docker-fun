#VERSIION 0.0.1
FROM ubuntu:14.04
MAINTAINER ycliu912 "ycliu1283@gmail.com"

#http://stackoverflow.com/questions/25019183/docker-java7-install-fail
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe"> /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

RUN echo "root:root" | chpasswd

#RUN apt-get install python-software-properties
#RUN add-apt-repository ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get install -y vim wget curl oracle-java7-installer tomcat7
#:<<!!
#RUN apt-get update -y                             && \
#    apt-get install python-software-properties -y && \
#    apt-get install software-properties-common -y && \
#    add-apt-repository ppa:webupd8team/java -y    && \
#    apt-get update -y                             && \
#    apt-get install oracle-java7-installer -y     && \
#    oracle-java7-set-default


#RUN update-alternatives --display java
#RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle">> /etc/environment
#RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle">> /etc/default/tomcat7


#EXPOSE 22
#EXPOSE 8080

#ENTRYPOINT service tomcat start && /usr/sbin/sshd -D
#!!

EXPOSE 22
ENTRYPOINT /usr/sbin/sshd -D
