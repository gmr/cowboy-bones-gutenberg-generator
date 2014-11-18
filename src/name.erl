-module({{NAME}}).

-export([start/0, start/2, stop/0, stop/1]).

start() ->
    application:set_env(gettext, gettext_dir, "translations"),
    {ok, _Started} = application:ensure_all_started({{NAME}}).

start(_StartType, _StartArgs) ->
    application:set_env(gettext, gettext_dir, "translations"),
    {{NAME}}_sup:start_link().

stop() ->
    application:stop({{NAME}}).

stop(_State) ->
    ok.
