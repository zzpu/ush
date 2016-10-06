FROM daocloud.io/ubuntu:14.04
MAINTAINER Fezzpu 

RUN mkdir -p /opt/workspace 
ENV GOPATH /opt/workspace
ENV DEBIAN_FRONTEND noninteractive
ADD sources.list /etc/apt/
# setup our Ubuntu sources (ADD breaks caching)
RUN echo "deb http://ubuntu.cn99.com/ubuntu/ precise main\n\
deb http://ubuntu.cn99.com/ubuntu/ precise multiverse\n\
deb http://ubuntu.cn99.com/ubuntu/ precise universe\n\
deb http://ubuntu.cn99.com/ubuntu/ precise restricted\n\
deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main\n\
"> /etc/apt/sources.list
#RUN rm /var/lib/apt/lists/* -vf && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y golang
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git

RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -fs /bin/true /sbin/initctl

RUN apt-get update

# install our "base" environment
RUN apt-get install -y --force-yes --no-install-recommends openssh-client=1:5.9p1-5ubuntu1
RUN apt-get install -y --no-install-recommends openssh-server sudo  vim-tiny

# install tty.js
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12
RUN apt-get install -y --force-yes nodejs
ADD tty.js /tty.js/

# clean up after ourselves
RUN apt-get clean
#RUN rm /etc/apt/apt.conf.d/90apt-cacher-ng

ADD startup.sh /
EXPOSE 22
EXPOSE 3000
WORKDIR /
ENTRYPOINT ["/startup.sh"]
