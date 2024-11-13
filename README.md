# PostgreSQL

REDMIC PostgreSQL database

Este proyecto establece la configuración necesaria para desplegar un servicio de base de datos PostgreSQL (funcionando sobre un clúster Docker Swarm), haciendo uso de GitLab-CI.

## Despliegue local

Aunque este proyecto está destinado a desplegar un servicio Docker Swarm, también se puede emplear la definición de imagen Docker para construirla y lanzar un contenedor Docker en entorno local.

### Construir imagen

La imagen Docker se puede construir de 2 maneras:

* Usando **docker compose** con la configuración *compose.yaml* y valores en *.env* (que se pueden sobreescribir mediante variables de entorno). Desde la raíz del proyecto, ejecutar:

```sh
IMAGE_NAME=redmic_postgresql \
  docker compose -f build/compose.yaml build
```

* Usando **docker build** y configuración mediante parámetros. Desde la raíz del proyecto, ejecutar:

```sh
docker build \
  --build-arg POSTGRES_IMAGE_TAG='...' \
  --build-arg LOCALES_VERSION='...' \
  --build-arg PLPYTHON3_VERSION='...' \
  --build-arg PYTHON3_PYSTACHE_VERSION='...' \
  --build-arg PGCRON_VERSION='...' \
  --build-arg POSTGIS_MAJOR='...' \
  --build-arg POSTGIS_VERSION='...' \
  --build-arg GETTEXT_BASE_VERSION='...' \
  -t redmic_postgresql:latest \
  build
```

### Lanzar contenedor

El despliegue necesita una red interna de Docker:

```sh
docker network create postgres-net
```

Para tener persistencia de datos, se puede vincular un directorio local (o volumen) al punto de montaje `/data` del contenedor. Esto también facilita la carga de datos inicial, ya que podemos añadir un fichero `.sql` con las sentencias deseadas.

Para lanzar el contenedor, usando la imagen Docker creada anteriormente y cargando un directorio local `./data`, ejecutar desde la raíz del proyecto:

```sh
docker run \
  --rm \
  --name local-postgresql \
  --network postgres-net \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=changeme \
  -e POSTGRES_DB=redmic \
  -v $(pwd)/data:/var/lib/postgresql/data \
  redmic_postgresql:latest
```

Luego, para poblar de datos el servicio a partir de un fichero *.sql* (por ejemplo, `input.sql`), se puede copiar al directorio local `./data` (para que esté disponible en el contenedor) y después ejecutar:

```sh
docker exec -it local-postgresql /bin/sh
  psql -d redmic -U postgres -f /var/lib/postgresql/data/input.sql
```
