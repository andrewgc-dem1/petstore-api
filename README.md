### General notes  12-12-25 - test1 today more secure check on TLS - tst 2

This is a bit of a hack, in that both the app and the database (MairaDB) are on the same image/container.

### Build notes

Building the python SQL access lib (flask_mysqldb) is "interesting".  It needs things like the MariaDB server installed.  See [here](https://mariadb.com/kb/en/installing-mariadb-on-macos-using-homebrew/) for notes on installing MariaDB on a Mac with Homebrew.

Also, if using a virtual environment, these extra flags are required to build flask_mysqldb:

	export LDFLAGS="-L/usr/local/opt/openssl/lib"
	export CPPFLAGS="-I/usr/local/opt/openssl/include"

Start MariaDB as shown in the link above.
To stop MariaDB, run `mysql` and enter the `SHUTDOWN;` command.

### Dockerfile notes

To build the Docker image:

	docker build -t petstore .
	
To run the Docker container:
	
	docker run --rm --name petstore -p 5000:5000 petstore

