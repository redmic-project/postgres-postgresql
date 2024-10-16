ARG POSTGRES_IMAGE_TAG=17

FROM postgres:${POSTGRES_IMAGE_TAG}

LABEL maintainer="info@redmic.es"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
	CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1

ARG LOCALES_VERSION \
	PLPYTHON3_VERSION \
	PYTHON3_PYSTACHE_VERSION \
	PGCRON_VERSION \
	POSTGIS_MAJOR \
	POSTGIS_VERSION \
	GETTEXT_BASE_VERSION

RUN apt-get update && \
	apt-cache showpkg \
		locales \
		"postgresql-plpython3-${PG_MAJOR}" \
		python3-pystache \
		"postgresql-${PG_MAJOR}-cron" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}" \
		gettext-base && \
	apt-get install -y --no-install-recommends \
		"locales=${LOCALES_VERSION}" \
		"postgresql-plpython3-${PG_MAJOR}=${PLPYTHON3_VERSION}" \
		"python3-pystache=${PYTHON3_PYSTACHE_VERSION}" \
		"postgresql-${PG_MAJOR}-cron=${PGCRON_VERSION}" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION}" \
		"postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts=${POSTGIS_VERSION}" \
		"gettext-base=${GETTEXT_BASE_VERSION}" && \
	rm -rf /var/lib/apt/lists/*

RUN localedef -i es_ES -c -f UTF-8 -A /usr/share/locale/locale.alias es_ES.UTF-8

ENV LANG=es_ES.utf8
