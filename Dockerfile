ARG POSTGRES_IMAGE_TAG=10.6

FROM postgres:${POSTGRES_IMAGE_TAG}

LABEL maintainer="info@redmic.es"

ENV PG_PORT="5432" \
	PG_MAX_CONNECTIONS="400" \
	PG_SHARED_PRELOAD_LIBRARIES="pg_cron" \
	POSTGRES_USER="postgres" \
	POSTGRES_PASSWORD="password" \
	CONFIG_PATH="/"

COPY scripts /tmp

ARG LOCALES_VERSION=2.24-11+deb9u4 \
	PLPYTHON3_VERSION=10.20-1.pgdg90+1 \
	PYTHON3_PYSTACHE_VERSION=0.5.4-6 \
	PGCRON_VERSION=1.4.1-2.pgdg90+1 \
	POSTGIS_MAJOR=2.5 \
	POSTGIS_VERSION=2.5.5+dfsg-1.pgdg90+2 \
	GETTEXT_BASE_VERSION=0.19.8.1-2+deb9u1

RUN apt-get update && \
	apt-cache madison \
		locales \
		"postgresql-plpython3-${PG_MAJOR}" \
		python3-pystache \
		"postgresql-${PG_MAJOR}-cron" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}" \
		gettext-base && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		"locales=${LOCALES_VERSION}" \
		"postgresql-plpython3-${PG_MAJOR}=${PLPYTHON3_VERSION}" \
		"python3-pystache=${PYTHON3_PYSTACHE_VERSION}" \
		"postgresql-${PG_MAJOR}-cron=${PGCRON_VERSION}" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION}" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts=${POSTGIS_VERSION}" \
		"gettext-base=${GETTEXT_BASE_VERSION}" && \
	rm -rf /var/lib/apt/lists/* && \
	localedef -i es_ES -c -f UTF-8 -A /usr/share/locale/locale.alias es_ES.UTF-8 && \
	mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-origin.sh && \
	mv /tmp/docker-entrypoint.sh /usr/local/bin/ && \
	mv /tmp/pg_hba.conf "/usr/share/postgresql/${PG_MAJOR}/pg_hba.conf.sample"

ENV LANG es_ES.utf8
