noop:
	@echo Please run make with a command.

deploy:
	heroku deploy:jar mojito-webapp.jar --includes "mojito-cli.jar:application.properties"

local:
	heroku local web

console:
	heroku run bash

reset-db:
	heroku addons:destroy cleardb --confirm=polis-translations
	heroku addons:create cleardb:ignite --version=5.7 --as=DATABASE
