DOCKER=/usr/bin/docker
REPOSITORY=lambci/lambda
RUNTIME=python3.6

UPDIR=upstream

POSTGRESQL_VERS=11.1
POSTGRESQL_FILE=postgresql-$(POSTGRESQL_VERS).tar.gz
POSTGRESQL_HASH=$(POSTGRESQL_FILE).sha256
POSTGRESQL_URL=https://ftp.postgresql.org/pub/source/v$(POSTGRESQL_VERS)

PSYCOPG2_VERS=2.8.3
PSYCOPG2_FILE=psycopg2-$(PSYCOPG2_VERS).tar.gz
PSYCOPG2_URL=http://initd.org/psycopg/tarballs/PSYCOPG-2.8
PSYCOPG2_ASC=$(PSYCOPG2_FILE).asc


DEPS=\
 $(UPDIR)/$(POSTGRESQL_FILE) \
 $(UPDIR)/$(POSTGRESQL_HASH) \
 $(UPDIR)/$(PSYCOPG2_FILE) \
 $(UPDIR)/$(PSYCOPG2_ASC)

.PHONY: deps pull clean purge

deps: $(DEPS)
	cd $(UPDIR) && sha256sum -c $(POSTGRESQL_HASH)

pull: $(DOCKER)
	$(DOCKER) pull $(REPOSITORY):build-$(RUNTIME)

clean:
	-rm -rf build

purge: clean
	-rm -rf $(UPDIR)
	-rm -rf dist

$(UPDIR)/$(POSTGRESQL_HASH):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -O $(POSTGRESQL_URL)/$(POSTGRESQL_HASH)	

$(UPDIR)/$(POSTGRESQL_FILE):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -O $(POSTGRESQL_URL)/$(POSTGRESQL_FILE)

$(UPDIR)/$(PSYCOPG2_FILE):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -O $(PSYCOPG2_URL)/$(PSYCOPG2_FILE)

$(UPDIR)/$(PSYCOPG2_ASC):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -O $(PSYCOPG2_URL)/$(PSYCOPG2_ASC)

