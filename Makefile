.PHONY: init
init: webapp/sql/dump.sql.bz2 benchmarker/userdata/img

webapp/sql/dump.sql.bz2:
	cd webapp/sql && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/dump.sql.bz2

benchmarker/userdata/img.zip:
	cd benchmarker/userdata && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/img.zip

benchmarker/userdata/img: benchmarker/userdata/img.zip
	cd benchmarker/userdata && \
	unzip -qq -o img.zip

prepare_local_tools:
	brew install percona-toolkit
	go install github.com/air-verse/air@latest
	go install github.com/matsuu/kataribe@latest

run_benchmarker:
	cd benchmarker; \
	./bin/benchmarker -t "http://localhost" -u ./userdata

run_local:
	$(eval ISUCONP_DB_HOST := localhost)
	$(eval ISUCONP_DB_PORT := 3306)
	$(eval ISUCONP_DB_USER := root)
	$(eval ISUCONP_DB_PASSWORD := root)
	$(eval ISUCONP_DB_NAME := isuconp)
	$(eval ISUCONP_MEMCACHED_ADDRESS := localhost:11211)
	cd webapp/golang; \
	ISUCONP_DB_HOST=$(ISUCONP_DB_HOST) ISUCONP_DB_PORT=$(ISUCONP_DB_PORT) ISUCONP_DB_USER=$(ISUCONP_DB_USER) ISUCONP_DB_PASSWORD=$(ISUCONP_DB_PASSWORD) ISUCONP_DB_NAME=$(ISUCONP_DB_NAME) ISUCONP_MEMCACHED_ADDRESS=$(ISUCONP_MEMCACHED_ADDRESS) air

