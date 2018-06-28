# DATABASE
Este repositorio es para guardar los elementos necesarios para preparar la base de datos. Este README está por hacer.

Ejecutar fichero sql desde consola

```
psql -U username -d myDataBase -a -f myInsertFile
```

# Extraer el schema desde una base de datos
```
pg_dump -h redmic.es -U postgres -W --schema=app --schema-only -d redmic > app.sql
```