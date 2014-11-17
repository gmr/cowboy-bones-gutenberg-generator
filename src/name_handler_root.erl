-module({{NAME}}_handler_root).

-export([init/3,
         content_types_provided/2,
         handle_html/2,
         handle_json/2,
         terminate/3]).

-include("{{NAME}}.hrl").

init(_Transport, _Req, _Opts) ->
    {upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
	{[
		{?MIME_TYPE_HTML, handle_html},
		{?MIME_TYPE_JSON, handle_json}
	], Req, State}.

terminate(_Reason, _Req, _State) ->
    ok.

handle_html(Req, State) ->
    Opts = [{translation_fun, ?TRANSLATE,
            {locale, cowboy_req:meta(language, Req)}],
    {ok, Body} = home_dtl:render(data(Req), Opts),
    {Body, Req, State}.

handle_json(Req, State) ->
    Data = {data(Req)},
    io:format("Data to encode: ~p~n", [Data]),
    {jiffy:encode(Data), Req, State}.

data(Req) ->
    {RawHeaders, _} = cowboy_req:headers(Req),
    Headers = [{maybe_fix(K), V} || {K, V} <- RawHeaders],
    [{headers, {Headers}},
     {apps, [[list_to_binary(atom_to_list(A)),
              list_to_binary(D),
              list_to_binary(V)] || {A, D, V} <- application:loaded_applications()]},
     {memory, {[{list_to_binary(atom_to_list(K)), V} || {K, V} <- erlang:memory()]}},
     {language, unknown},
     {node, erlang:node()},
     {system_version, list_to_binary(erlang:system_info(system_version))},
     {proc_count, erlang:system_info(process_count)},
     {architecture, list_to_binary(erlang:system_info(system_architecture))}].

maybe_fix(K) ->
    list_to_binary([maybe_replace_dash(X) || X <- binary_to_list(K)]).

maybe_replace_dash(K) ->
    case K of
        45 -> "_";
        _ -> K
    end.

maybe_nest(V) ->
    case is_proplist(V) of
        true -> {V};
        false -> V
    end.

is_proplist(V) when is_list(V) ->
    IsAtom = fun(X) when is_atom(X) -> true; ({X,_}) when is_atom(X) -> true; (_) -> false end,
    lists:all(IsAtom, V);
is_proplist(_) -> false.
