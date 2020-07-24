heroku-app-name=polis-translations
mojito-version=0.110
MOJITO=java -jar mojito-cli.jar
project-name=polis:client-participation
locales=es-419 "(da-DK)" de-DE fr-FR it-IT ja-JP nl-NL pt-BR zh-TW zh-CN

# Command affecting LOCAL workstation state.

check-java:
	@java -version 2>&1 | grep '1.8' > /dev/null || (echo 'Must be using Java 8. Exiting...' && exit 1)

setup: ## Prepare local workstation and download deployable files
	heroku git:remote $(heroku-app-name)
	heroku plugins:install java
	wget --continue --progress=bar --output-document=mojito-webapp.jar https://github.com/box/mojito/releases/download/v$(mojito-version)/mojito-webapp-$(mojito-version).jar
	wget --continue --progress=bar --output-document mojito-cli.jar https://github.com/box/mojito/releases/download/v$(mojito-version)/mojito-cli-$(mojito-version).jar

config-pull: ## Override local .env with heroku envvvars
	heroku config --shell >> .env

local: ## Run webapp locally using local .env
	heroku local web

# Command affecting REMOTE state.

deploy: ## Deploy the app to Heroku
	heroku deploy:jar mojito-webapp.jar --jdk=8 --includes "mojito-cli.jar:application.properties"

console: ## Run a remote shell console on Heroku
	heroku run bash

delete-db: check ## Delete the remote Heroku database
	heroku addons:destroy jawsdb --confirm=$(heroku-app-name)

db: ## Create the remote Heroku database
	heroku addons:create  jawsdb:kitefin --version=5.7 --as=DATABASE

project: ## Create a new translation project (AKA repo)
	heroku local:run $(MOJITO) repo-create --name $(project-name) -d "Polis" --locales $(locales)

project-update: check-java ## Update the translation project (AKA repo)
	heroku local:run $(MOJITO) repo-update --name $(project-name) -d "Polis" --locales $(locales)

project-import: ## Import initial strings to populate project in Mojito TMS
ifndef SRC_PATH
	@echo "SRC_PATH not set. Aborting..."
	@exit 1
endif
	heroku local:run $(MOJITO) import --repository $(project-name) --source-directory "${SRC_PATH}"

project-push: ## Push strings to project in Mojito TMS
ifndef SRC_PATH
	@echo "SRC_PATH not set. Aborting..."
	@exit 1
endif
	heroku local:run $(MOJITO) push --repository $(project-name) --source-directory "${SRC_PATH}"

project-pull: ## Pull strings from project in Mojito TMS
ifndef SRC_PATH
	@echo "SRC_PATH not set. Aborting..."
	@exit 1
endif
	heroku local:run $(MOJITO) pull --repository $(project-name) --source-directory "${SRC_PATH}" --inheritance-mode REMOVE_UNTRANSLATED

project-delete: check ## Delete the polis project from Mojito TMS. CAREFUL.
	heroku local:run $(MOJITO) repo-delete --name $(project-name)

project-init: project project-push project-import

project-reset: project-delete project-init

reset-db: delete-db db ## Delete and recreate the remote Heroku database

change-password: ## Change password for admin CLI user
	heroku local:run $(MOJITO) user-update --username admin --password
	@echo
	@echo ">>> Success! Password changed."
	@echo
	@echo "    Remember to update any MOJITO_CLI_PASSWORD envvar wherever it's used, including:"
	@echo "      - within the .env file of the current directory, and"
	@echo "      - within the "Secrets" setting of any GitHub repos, used for Github Action workflows."

stop: ## Stop the Heroku webapp
	heroku ps:scale web=0

start: ## Start the Heroku webapp
	heroku ps:scale web=1

logs: ## Tail the remote Heroku logs
	heroku logs --tail

fresh: stop reset-db deploy start ## Purge and recreate the database and deploy the current app fresh

fresh-tail: fresh logs ## Start fresh, and immediately tail the logs

%:
	@true

.PHONY: help

check: # A sanity check
	@echo Warning: "Warning: This is a destructive action! Continue? [Y/n]"
	@read line; if [ $$line = "n" ]; then echo aborting; exit 1 ; fi

help:
	@echo 'Usage: make <command>'
	@echo
	@echo 'where <command> is one of the following:'
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
