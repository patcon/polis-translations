heroku-app-name=polis-translations
mojito-version=0.110

noop:
	@echo Please run make with a command.

# Command affecting LOCAL workstation state.

setup:
	heroku git:remote $(heroku-app-name)
	heroku plugins:install java
	wget --continue --progress=bar --output-document=mojito-webapp.jar https://github.com/box/mojito/releases/download/v$(mojito-version)/mojito-webapp-$(mojito-version).jar
	wget --continue --progress=bar --output-document mojito-cli.jar https://github.com/box/mojito/releases/download/v$(mojito-version)/mojito-cli-$(mojito-version).jar

config-pull:
	heroku config --shell >> .env

local:
	heroku local web

# Command affecting REMOTE state.

deploy:
	heroku deploy:jar mojito-webapp.jar --jdk=8 --includes "mojito-cli.jar:application.properties"

console:
	heroku run bash

delete-db:
	heroku addons:destroy jawsdb --confirm=$(heroku-app-name)

db:
	heroku addons:create  jawsdb:kitefin --version=5.7 --as=DATABASE

init-db:
	heroku local:run mojito repo-create --name polis -d "Polis" --locales es-419 da-DK de-DE fr-FR it-IT ja-JP nl-NL pt-BR zh-TW zh-CN
	heroku local:run mojito push --repository polis --source-directory /tmp/polis-test

reset-db: delete-db db

stop:
	heroku ps:scale web=0

start:
	heroku ps:scale web=1

logs:
	heroku logs --tail

fresh: stop reset-db deploy start

fresh-tail: fresh logs
