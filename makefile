DC = docker compose
STORAGES_FILE = docker_compose/storages.yaml
EXEC = docker exec -it
DB_CONTAINER = example-db
LOGS = docker logs
ENV = --env-file .env
APP_FILE = docker_compose/app.yaml
APP_CONTAINER = main-app
MANAGE_PY = python manage.py
DB_NAME = clean_marketplace
POETRY = poetry run
TESTS_FILE = tests/
PYTEST_FLAGS = --verbose --disable-warnings --exitfirst --capture=no


# Postgres DB storage
.PHONY: storages
storages:
	${DC} -f ${STORAGES_FILE} ${ENV} up -d

.PHONY: storages-down
storages-down:
	${DC} -f ${STORAGES_FILE} down

.PHONY: postgres
postgres:
	${EXEC} ${DB_CONTAINER} psql -U postgres

.PHONY: postgres-db
postgres-db:
	${EXEC} ${DB_CONTAINER} psql -U postgres --dbname=${DB_NAME}

.PHONY: storages-logs
storages-logs:
	${LOGS} ${DB_CONTAINER} -f

# Main App
.PHONY: app
app:
	${DC} -f ${APP_FILE} -f ${STORAGES_FILE} ${ENV} up --build -d

.PHONY: app-down
app-down:
	${DC} -f ${APP_FILE} -f ${STORAGES_FILE} down

.PHONY: app-logs
app-logs:
	${LOGS} ${APP_CONTAINER} -f

# Django
.PHONY: migrate
migrate:
	${EXEC} ${APP_CONTAINER} ${MANAGE_PY} migrate

.PHONY: migrations
migrations:
	${EXEC} ${APP_CONTAINER} ${MANAGE_PY} makemigrations

.PHONY: superuser
superuser:
	${EXEC} ${APP_CONTAINER} ${MANAGE_PY} createsuperuser

.PHONY: collectstatic
collectstatic:
	${EXEC} ${APP_CONTAINER} ${MANAGE_PY} collectstatic

# OS
.PHONY: ash
ash:
	${EXEC} ${APP_CONTAINER} ash

.PHONY: django-shell
django-shell:
	${EXEC} ${APP_CONTAINER} ${MANAGE_PY} shell -i ipython

# Tests
.PHONY: pytest
pytest:
	${POETRY} pytest ${PYTEST_FLAGS} ${TESTS_FILE}

.PHONY: run-test
run-test:
	${EXEC} ${APP_CONTAINER} pytest ${PYTEST_FLAGS} ${TESTS_FILE}
