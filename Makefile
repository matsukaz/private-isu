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

run_local_app:
	$(eval ISUCONP_DB_HOST := localhost)
	$(eval ISUCONP_DB_PORT := 3306)
	$(eval ISUCONP_DB_USER := root)
	$(eval ISUCONP_DB_PASSWORD := root)
	$(eval ISUCONP_DB_NAME := isuconp)
	$(eval ISUCONP_MEMCACHED_ADDRESS := localhost:11211)
	cd webapp/golang; \
	ISUCONP_DB_HOST=$(ISUCONP_DB_HOST) ISUCONP_DB_PORT=$(ISUCONP_DB_PORT) ISUCONP_DB_USER=$(ISUCONP_DB_USER) ISUCONP_DB_PASSWORD=$(ISUCONP_DB_PASSWORD) ISUCONP_DB_NAME=$(ISUCONP_DB_NAME) ISUCONP_MEMCACHED_ADDRESS=$(ISUCONP_MEMCACHED_ADDRESS) air

docker_up:
	cd webapp; \
	docker compose up -d

docker_down:
	cd webapp; \
	docker compose down

docker_logs:
	cd webapp; \
	docker compose logs -f

docker_rebuild_app:
	cd webapp; \
	docker compose up -d --no-deps --build app

set_slow_query_on:
	rm -f logs/mysql/*.log; \
	scripts/profile/slow_query.sh on

set_slow_query_off:
	scripts/profile/slow_query.sh off

set_kataribe_on:
	scripts/profile/kataribe.sh on; \
	rm -f logs/nginx/*.log; \
	cd webapp; \
	docker compose restart nginx

set_kataribe_off:
	scripts/profile/kataribe.sh off; \
	cd webapp; \
	docker compose restart nginx

set_pprof_on:
	scripts/profile/pprof.sh on

set_pprof_off:
	scripts/profile/pprof.sh off

profile_kataribe:
	scripts/profile_kataribe.sh

profile_slow_query:
	scripts/profile_pt-query-digest.sh

profile_pprof:
	go tool pprof -seconds 60 -http=localhost:1080 http://localhost:6060/debug/pprof/profile
