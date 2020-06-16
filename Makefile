heroku-app-name=polis-translations
mojito-version=0.110

# Command affecting LOCAL workstation state.

setup: ## prepare workstation and download deployable files
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

delete-db: ## Delete the remote Heroku database
	heroku addons:destroy jawsdb --confirm=$(heroku-app-name)

db: ## Create the remote Heroku database
	heroku addons:create  jawsdb:kitefin --version=5.7 --as=DATABASE

init-db: 
	heroku local:run mojito repo-create --name polis -d "Polis" --locales es-419 da-DK de-DE fr-FR it-IT ja-JP nl-NL pt-BR zh-TW zh-CN
	heroku local:run mojito push --repository polis --source-directory /tmp/polis-test

reset-db: delete-db db ## Delete and recreate the remote Heroku database

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

help:
	@echo 'Usage: make <command>'
	@echo
	@echo 'where <command> is one of the following:'
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
