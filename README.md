# psycopg2-lambda
Build psycopg2 for AWS Lambda functions in both python2.7 and python3.6

## Tools required

- Can only build this on Linux
- Need docker and access to docker hub
- Need make installed

## How to run

Download the tarballs for the upstream sources (postgresql and psycopg2)

```
make deps
```

Pull the images this needs

```
make pull
```

Build a ZIP containing the psycopg2 code, statically linked

```
make build
```

## Vary what is built

You can build for python 2.7 like this:

```
make RUNTIME=python2.7 build
```

You can change the version of psycopg2 or postgresql. You will need to pass the same arguments to the build:

```
make POSTGRESQL_VERS=10.6 PSYCOPG2_VERS=2.8.1 deps
```
