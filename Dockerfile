FROM centos:latest
MAINTAINER Martin Stanchev <connect.martin97@gmail.com>

RUN yum -y update
RUN yum -y install nano
COPY mfs.sh /etc/mfs.sh
RUN chmod 755 /etc/mfs.sh
WORKDIR /etc
CMD ["mfs.sh"]