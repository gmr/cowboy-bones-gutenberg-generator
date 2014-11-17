-module({{NAME}}_handler_root).

-export([init/3,
         content_types_provided/2,
         handle_html/2,
         handle_json/2,
         languages_provided/2,
         terminate/3]).
-export([handle/2]).
-export([terminate/3]).

-include("{{NAME}}.hrl").

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
	{[
		{?MIME_TYPE_HTML, handle_html},
		{?MIME_TYPE_JSON, handle_json}
	], Req, State}.

languages_provided(Req, State) ->
    {gettext:all_lcs(), Req, State}.

terminate(_Reason, _Req, _State) ->
    ok.

handle_html(Req, State) ->
    Opts = [{translation_fun, ?TRANSLATE,
            {locale, cowboy_req:meta(language, Req)}],
    {ok, Body} = editor_dtl:render(data(), Opts),
    Headers = [{<<"Content-Type">>, ?MIME_TYPE_HTML}],
    {ok, Req2} = cowboy_req:reply(200, Headers, Body, Req),
    {ok, Req2, State}.

handle_json(Req, State) ->
    Headers = [{<<"Content-Type">>, ?MIME_TYPE_JSON}],
    {ok, Req2} = cowboy_req:reply(200, Headers, jsx:encode(data()), Req),
    {ok, Req2, State}.


data(Req) ->
    [
        {language, cowboy_req:meta(language, Req)},
        {available, gettext:all_lcs()}
    ].
