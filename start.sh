#!/bin/bash

# start up mariadb
/etc/init.d/mariadb setup
/usr/bin/mariadbd-safe --datadir='/var/lib/mysql' &

# wait for mariadb to be running
sleep 5
#mysqladmin --silent --wait=30 ping || exit 1
mysqladmin --wait=30 ping || exit 1

# database setup
mysql -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost";'
mysql -e "CREATE DATABASE flask_api;"
mysql -e "CREATE USER 'petstore'@'localhost' IDENTIFIED BY 'Ver@c0de';"
mysql -e "GRANT ALL ON *.* TO 'petstore'@'localhost';"
mysql -e "flush privileges;"

# this while/true loop *should* not be necessary with the switch to 'debug=False' 
# in the flask app, but better safe than sorry
while true; do
    python api.py
done
