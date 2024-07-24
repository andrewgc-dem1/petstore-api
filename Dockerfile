FROM alpine:3.20.2

RUN mkdir /api

RUN apk add mariadb mariadb-client python3 py3-pip openrc mariadb-dev
RUN apk add --no-cache --virtual .build-deps pkgconfig gcc musl-dev python3-dev

RUN rc-status -a
RUN touch /run/openrc/softlevel

# set the SQL DB port (necessary?)
#RUN sed -i '/\[mysqld\]/aport=3306' /etc/my.cnf

# ?? VOLUME ["/var/lib/mysql"]

RUN /etc/init.d/mariadb setup
RUN rc-service mariadb start

# RUN \
#   echo "/usr/bin/mysqld_safe --basedir=/usr &" > /tmp/config && \
#   echo "cat /var/log/mariadb/mariadb.log" >> /tmp/config && \
#   echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
#   echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"localhost\";'" >> /tmp/config && \
#   bash /tmp/config && \
#   rm -f /tmp/config

COPY . /api
WORKDIR /api
RUN pip3 install --break-system-packages -r requirements.txt

# delete packages needed to build the python libs
RUN apk del .build-deps

ENTRYPOINT [ "/bin/sh" ]
CMD ["./start.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]