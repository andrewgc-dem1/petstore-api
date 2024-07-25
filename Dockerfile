FROM alpine:3.20.2

RUN apk add mariadb mariadb-client python3 py3-pip openrc mariadb-dev
RUN apk add --no-cache --virtual .build-deps pkgconfig gcc musl-dev python3-dev

RUN mkdir -p /run/openrc
RUN touch /run/openrc/softlevel

RUN sed -i '/\[mysqld\]/aport=3306' /etc/my.cnf
RUN sed -i 's/skip-networking/#skip-networking/' /etc/my.cnf.d/mariadb-server.cnf

VOLUME ["/sys/fs/cgroup"]

RUN mkdir /api
COPY . /api
WORKDIR /api

# 'break-system-packages' since we're running as root and installing into the system python
RUN pip3 install --break-system-packages -r requirements.txt

# delete packages needed to build the python libs
RUN apk del .build-deps

ENTRYPOINT [ "/bin/sh" ]
CMD ["./start.sh"]
