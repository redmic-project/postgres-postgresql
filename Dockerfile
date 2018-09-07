FROM postgres:10.3

ENV PG_PORT="5432" \
	PG_MAX_CONNECTIONS="400" \
	PG_SHARED_PRELOAD_LIBRARIES="pg_cron" \
	POSTGRES_USER="postgres" \
	POSTGRES_PASSWORD="password" \
	PG_POSTGIS_VERSION="2.4" \
	CONFIG_PATH="/"

COPY scripts /tmp

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		locales \
		postgresql-plpython-${PG_MAJOR} \
		postgresql-${PG_MAJOR}-cron \
		postgresql-${PG_MAJOR}-postgis-${PG_POSTGIS_VERSION} \
		postgresql-${PG_MAJOR}-postgis-${PG_POSTGIS_VERSION}-scripts \
		gettext-base \
	&& rm -rf /var/lib/apt/lists/* \
	&& localedef -i es_ES -c -f UTF-8 -A /usr/share/locale/locale.alias es_ES.UTF-8 \
	&& mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-origin.sh \
	&& mv /tmp/docker-entrypoint.sh /usr/local/bin/ \
	&& mv /tmp/pg_hba.conf /usr/share/postgresql/${PG_MAJOR}/pg_hba.conf.sample

ENV LANG es_ES.utf8
