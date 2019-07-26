REPOSITORY=lambci/lambda
RUNTIME=python3.6

BUILD_IMAGE=$(REPOSITORY):build-$(RUNTIME)

POSTGRESQL_VERS=11.1
POSTGRESQL_FILE=postgresql-$(POSTGRESQL_VERS).tar.gz
POSTGRESQL_HASH=$(POSTGRESQL_FILE).sha256
POSTGRESQL_URL=https://ftp.postgresql.org/pub/source/v$(POSTGRESQL_VERS)

PSYCOPG2_VERS=2.8.3
PSYCOPG2_FILE=psycopg2-$(PSYCOPG2_VERS).tar.gz
PSYCOPG2_URL=http://initd.org/psycopg/tarballs/PSYCOPG-2-8
PSYCOPG2_ASC=$(PSYCOPG2_FILE).asc

UID=$(shell stat -c '%u' Makefile)
GID=$(shell stat -c '%g' Makefile)

UPDIR=upstream

DEPS=\
 $(UPDIR)/$(POSTGRESQL_FILE) \
 $(UPDIR)/$(POSTGRESQL_HASH) \
 $(UPDIR)/$(PSYCOPG2_FILE) \
 $(UPDIR)/$(PSYCOPG2_ASC)

.PHONY: deps pull clean purge build
	
deps: $(DEPS)

pull:
	docker pull $(BUILD_IMAGE)

build: psycopg2-${PSYCOPG2_VERS}-${RUNTIME}.zip

psycopg2-$(PSYCOPG2_VERS)-$(RUNTIME).zip: deps
	docker run --rm \
		-v ${PWD}:/var/task \
		$(BUILD_IMAGE) \
		bash -c "./build.sh $(POSTGRESQL_VERS) $(PSYCOPG2_VERS) $(UID) $(GID)"
	mv psycopg2.zip $@

clean:
	-rm -rf psycopg2*.zip

purge: clean
	-rm -rf $(UPDIR)

$(UPDIR)/$(POSTGRESQL_HASH):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -L -O $(POSTGRESQL_URL)/$(POSTGRESQL_HASH)	

$(UPDIR)/$(POSTGRESQL_FILE):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -L -O $(POSTGRESQL_URL)/$(POSTGRESQL_FILE)

$(UPDIR)/$(PSYCOPG2_FILE):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -L -O $(PSYCOPG2_URL)/$(PSYCOPG2_FILE)

$(UPDIR)/$(PSYCOPG2_ASC):
	-mkdir $(UPDIR) 2>/dev/null
	cd $(UPDIR) && curl -L -O $(PSYCOPG2_URL)/$(PSYCOPG2_ASC)

