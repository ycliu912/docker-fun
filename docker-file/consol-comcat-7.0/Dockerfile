FROM tomcat:7-jre7
MAINTAINER "ycliu <ycliu912@gmail.com>"
RUN apt-get update &&  apt-get install -y openssh-server vim  && mkdir /var/run/sshd && /usr/sbin/sshd
RUN echo "root:douins" | chpasswd
EXPOSE 22
