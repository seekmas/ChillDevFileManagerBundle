##
# This file is part of the ChillDev FileManager bundle.
#
# @author Rafał Wrzeszcz <rafal.wrzeszcz@wrzasq.pl>
# @copyright 2012 © by Rafał Wrzeszcz - Wrzasq.pl.
# @version 0.0.1
# @since 0.0.1
# @package ChillDev\Bundle\FileManagerBundle
##

# environment-vary commands
PHP = $(shell which php)
COMPOSER = $(shell which composer.phar)
PHPDOC = $(shell which phpdoc)
PHPCS = ./vendor/bin/phpcs
PHPUNIT = ./vendor/bin/phpunit

# meta-targets

default: all

all: check lint tests documentation

# project initialization
init:
	git submodule update --init --recursive
	$(COMPOSER) install

# update composer dependencies
update:
	$(COMPOSER) update

# syntax checking
check:
	find . -path "./vendor" -prune -o -name "*.php" -exec $(PHP) -l {} \;

# conde linting
lint:
	$(PHPCS) --standard=PSR2 --encoding=utf-8 --extensions=php --ignore=Tests --ignore=vendor --ignore=Resources .

# tests running
tests:
	$(PHPUNIT)

# documentation generation
documentation:
	$(PHPDOC) -t Resources/doc/gh-pages -d . -i "Tests/*" -i "vendor/*" -i "Resources/*" --title "ChillDev FileManager Bundle - by Chillout Development" --sourcecode --parseprivate
	#FIXME: this is temporary, until phpDocumentor2 will provide some convenient way for generating text pages and templates customization
	find Resources/doc/gh-pages -name "*.html" -exec sed "s|<body>|<body>\\n<div id=\"ribbon\"><a href=\"https://github.com/chilloutdevelopment/ChillDevFileManagerBundle\" rel=\"me\">Fork me on GitHub</a></div>|g" {} -i \;
	echo "\
/* after http://unindented.org/articles/2009/10/github-ribbon-using-css-transforms/ */\
#ribbon {\
    background-color: #a00;\
    overflow: hidden;\
    /* top left corner */\
    position: absolute;\
    left: -3em;\
    top: 2.5em;\
    z-index: 2000;\
    /* 45 deg ccw rotation */\
    -moz-transform: rotate(-45deg);\
    -webkit-transform: rotate(-45deg);\
    /* shadow */\
    -moz-box-shadow: 0 0 1em #888;\
    -webkit-box-shadow: 0 0 1em #888;\
}\
\
#ribbon a {\
    border: 1px solid #faa;\
    color: #fff;\
    display: block;\
    font: bold 81.25% 'Helvetiva Neue', Helvetica, Arial, sans-serif;\
    margin: 0.05em 0 0.075em 0;\
    padding: 0.5em 3.5em;\
    text-align: center;\
    text-decoration: none;\
    /* shadow */\
    text-shadow: 0 0 0.5em #444;\
}" >> Resources/doc/gh-pages/css/template.css
