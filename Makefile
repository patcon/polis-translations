noop:
	@echo Please run make with a command.

# Command affecting LOCAL workstation state.

setup:
	heroku git:remote polis-translations
	heroku plugins:install java
	wget --continue --progress=bar --output-document=mojito-webapp.jar https://github.com/box/mojito/releases/download/v0.110/mojito-webapp-0.110.jar
	wget --continue --progress=bar --output-document mojito-cli.jar https://github.com/box/mojito/releases/download/v0.110/mojito-cli-0.110.jar

config-pull:
	heroku config --shell > .env

local:
	heroku local web

# Command affecting REMOTE state.

deploy:
	heroku deploy:jar mojito-webapp.jar --jdk=8 --includes "mojito-cli.jar:application.properties"

console:
	heroku run bash

delete-db:
	heroku addons:destroy jawsdb --confirm=polis-translations

db:
	heroku addons:create  jawsdb:kitefin --version=5.7 --as=DATABASE

reset-db: delete-db db
