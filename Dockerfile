FROM zalando/openjdk:8u45-b14-3

MAINTAINER Zalando <team-mop@zalando.de>

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://debian.datastax.com/community stable main" | \
        tee -a /etc/apt/sources.list.d/datastax.community.list
RUN curl -sL http://debian.datastax.com/debian/repo_key | sudo apt-key add -

RUN apt-get -y update && \
    apt-get -y -o Dpkg::Options::='--force-confold' dist-upgrade && \
    apt-get -y install opscenter

# Expose ports
EXPOSE 8888 61620

COPY stups-opscenter.sh /usr/share/opscenter/bin/

CMD /usr/share/opscenter/bin/stups-opscenter.sh


