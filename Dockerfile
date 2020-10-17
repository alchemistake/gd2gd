FROM ubuntu:bionic
MAINTAINER alchemistake <alchemistake@gmail.com>

ENV FROM_PATH="/mnt/from"
ENV TO_PATH="/mnt/to"
ENV KEEP_LAST=30
ENV RESTIC_REPOSITORY=$TO_PATH

RUN  apt-get update \
 && apt-get install -yy gnupg wget\
 && echo "deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu bionic main" >> /etc/apt/sources.list \
 && echo "deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu bionic main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F639B041 \
 && apt-get update \
 && apt-get install -yy google-drive-ocamlfuse fuse \
 && apt-get clean all \
 && echo "user_allow_other" >> /etc/fuse.conf \
 && rm /var/log/apt/* /var/log/alternatives.log /var/log/bootstrap.log /var/log/dpkg.log

RUN wget https://github.com/restic/restic/releases/download/v0.9.1/restic_0.9.1_linux_amd64.bz2 \
    && bunzip2 restic* \
    && cp restic* /usr/local/bin/restic \
    && chmod a+x /usr/local/bin/restic

COPY restic_backup.sh /usr/local/bin/
COPY connect_to_gd.sh /usr/local/bin/

CMD ["restic_backup.sh"]
