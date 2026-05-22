# template-quarkus-vps

Template GitHub per backend Quarkus 3.17 + Java 21 + Postgres, predisposto per il deploy automatico sul VPS `zaknafein.ovh` (vedi [PLAYBOOK_DEPLOY.md](https://github.com/zaknafein83/PLAYBOOK_DEPLOY.md) — non ancora pubblicato).

## Come usarlo

### Da n8n (consigliato)
Vai su `https://man8n.zaknafein.ovh/form/create-project`, scegli Stack: `Quarkus`. Il workflow crea repo + DNS + VPS + Telegram in ~90s.

### A mano (se preferisci capirlo passo passo)
```bash
# 1. Crea repo da template via gh CLI
gh repo create zaknafein83/myproject --template zaknafein83/template-quarkus-vps --public --clone

# 2. Entra e rinomina ovunque "myapp" → "myproject"
cd myproject
./init-rename.sh myproject

# 3. Primo commit del rename
git add -A && git commit -m "init: rename myapp → myproject"

# 4. Push su un branch di feature, apri PR, mergia → deploy parte
```

## Stack incluso

| Layer | Tecnologia | Versione |
|---|---|---|
| Linguaggio | Java | 21 (LTS) |
| Framework | Quarkus | 3.17.x |
| Persistenza | Hibernate ORM Panache + Postgres | 15-alpine |
| Migrazioni | Flyway | 10.x |
| Validation | hibernate-validator | (Quarkus BOM) |
| Health | smallrye-health (`/q/health/ready` esposto) | (Quarkus BOM) |
| Test | JUnit 5 + RestAssured | (Quarkus BOM) |
| Container | Docker multi-stage (Maven + JRE Alpine) | |
| Deploy | GitHub Actions → GHCR → SSH al VPS | |

## File del template

```
.
├── Dockerfile                  Multi-stage Maven → JRE Alpine
├── docker-compose.yml          db (Postgres) + app + healthcheck. Variante Mongo commentata.
├── .env.example                DB_PASSWORD, JWT_SECRET (genera random a deploy)
├── .gitignore
├── LICENSE                     MIT
├── pom.xml                     Quarkus 3.17 + dipendenze base
├── application.properties      Config con env vars
├── src/main/java/it/myapp/
│   └── HelloResource.java      Endpoint GET /hello (per smoke test)
├── src/main/resources/
│   ├── application.properties
│   └── db/migration/V1__init.sql
├── src/test/java/it/myapp/
│   └── HelloResourceTest.java  Test JUnit di /hello
├── .github/workflows/
│   └── deploy.yml              Pipeline CI/CD su push main
└── init-rename.sh              Script di rename da lanciare una volta dopo il clone
```

## Switch a MongoDB

Aprire `pom.xml` → commentare il blocco "Postgres" e decommentare il blocco "MongoDB".
Aprire `docker-compose.yml` → idem (sostituire servizio `db`).
Aprire `application.properties` → idem (commentare riga `quarkus.datasource.*`, attivare `quarkus.mongodb.*`).
Adattare entity/service: Hibernate Panache JPA → MongoDB Panache (annotazione `@MongoEntity` invece di `@Entity`).

## Variabili d'ambiente attese dal container

| Variabile | Default in dev | Descrizione |
|---|---|---|
| `DB_URL` | `jdbc:postgresql://db:5432/myapp` | URL JDBC |
| `DB_USER` | `myapp` | Utente PostgreSQL |
| `DB_PASSWORD` | `myapp` | Password PostgreSQL |
| `JWT_SECRET` | `dev-secret-key-must-be-at-least-32-chars` | HMAC JWT (min 32 char) |
| `CORS_ORIGINS` | `http://localhost:5173` | Origini CORS consentite (separare con virgole) |
| `TAG` | `latest` | Tag immagine GHCR (impostato dal workflow) |

## Endpoint di default

- `GET /hello` → "Hello from myapp"
- `GET /q/health` → readiness + liveness combinato
- `GET /q/health/ready` → readiness (controllato dal CI healthcheck)
- `GET /q/health/live` → liveness

## Licenza

[MIT](LICENSE)
