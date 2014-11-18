REBAR = `which rebar`
RELX = `which relx`
XGETTEXT = `which xgettext`

NAME = {{NAME}}
COMPANY = {{NAME}}
VERSION = 0.1.0
YEAR = `date +%Y`
FULLNAME = `git config --global --get user.name`
EMAIL = `git config --global --get user.email`

CHARSET = ISO-8859-1
GETTEXT_DIR = translations
DEFAULT_LANGUAGE = en
PO_PATH = $(GETTEXT_DIR)/lang/default/$(DEFAULT_LANGUAGE)

BOOTSTRAP = bower_components/bootstrap

all: deps po compile

bower:
	@( bower install )

bootstrap: bower
	@( cp -R $(BOOTSTRAP)/dist/* static/ )

static: bootstrap

deps: bootstrap
	@( $(REBAR) get-deps )

compile:
	@( $(REBAR) compile )

clean:
	@( $(REBAR) clean )
	@( rm -f static/css/* )
	@( rm -f static/fonts/* )
	@( rm -f static/js/* )
	@( rm -f erl_crash.dump )
	@( rm -f $(PO_PATH)/gettext.po )
	@( rm -f translations/gettext_server_db.dets )

run:
	@( erl -pa  ebin deps/*/ebin -s {{NAME}} )

release: compile
	@( $(RELX) release )

po:
	@( mkdir -p $(PO_PATH) )
	@( $(XGETTEXT) -L c -k_ -d gettext -s -p $(PO_PATH) --package-name="$(NAME)" --package-version="$(VERSION)" templates/*.dtl )
	@( sed -i "" "s/YEAR/$(YEAR)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/THE PACKAGE'S COPYRIGHT HOLDER/$(COMPANY)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/SOME DESCRIPTIVE TITLE./$(NAME)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/PACKAGE/$(NAME)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/FIRST AUTHOR/$(FULLNAME)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/FULL NAME/$(FULLNAME)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/EMAIL@ADDRESS/$(EMAIL)/g" $(PO_PATH)/gettext.po )
	@( sed -i "" "s/CHARSET/$(CHARSET)/g" $(PO_PATH)/gettext.po )
	@( msgen -o $(PO_PATH)/gettext.po $(PO_PATH)/gettext.po )
	@( echo "Updated $(PO_PATH)/gettext.po" )

.PHONY: all deps compile clean run
