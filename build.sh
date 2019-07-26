#!/bin/bash

if [[ $# -ne 4 ]]; then
	echo "Usage: $0 <postgresql_version> <psycopg2_version> <uid> <gid>" 1>&2 
	exit 1
fi

POSTGRESQL_VERS=postgresql-$1
PSYCOPG2_VERS=psycopg2-$2
TARGET_UID=$3
TARGET_GID=$4

# Build postgresql
cd /opt
tar xvf /var/task/upstream/${POSTGRESQL_VERS}.tar.gz
cd ${POSTGRESQL_VERS}

./configure --prefix $PWD \
	--without-readline \
	--without-zlib \
	--with-openssl

make
make install


cd /opt
tar xvf /var/task/upstream/${PSYCOPG2_VERS}.tar.gz
cd ${PSYCOPG2_VERS}

sed -i \
  -e "s,^pg_config.*,pg_config = ../${POSTGRESQL_VERS}/bin/pg_config," \
  -e 's/^static_libpq.*/static_libpq = 1/' \
  -e 's/^libraries.*/libraries = ssl crypto/' \
  setup.cfg

python setup.py build

cd build/lib.linux*
zip -r /var/task/psycopg2.zip psycopg2
chown $TARGET_UID:$TARGET_GID /var/task/psycopg2.zip
