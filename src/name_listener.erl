%% ------------------------------------------------------------------
%% Cowboy Listener
%% ------------------------------------------------------------------
-module({{NAME}}_listener).

-behaviour(gen_server).

-export([start_link/0,
         init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-include("{{NAME}}.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    Dispatch = cowboy_router:compile({{NAME}}_routes:get()),
    cowboy:start_http({{NAME}}_cowboy_listener,
                      listener_count(),
                      [{port, port()}],
                      [{env, [{dispatch, Dispatch}]},
                       {timeout, timeout()},
                       {onresponse, fun on_response/4}]),
    {ok, {}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    cowboy:stop_listener({{NAME}}_cowboy_listener).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Response handling behaviors
%% ------------------------------------------------------------------

on_response(Code, _Headers, _Body, Req) when is_integer(Code), Code >= 400 ->
    lager:log(info, self(), "~p ~s ~s", [Code, cowboy_req:method(Req), cowboy_req:path(Req)]),
    Message = proplists:get_value(Code, ?STATUS_CODES, <<"Undefined Error Code">>),
    Opts = [{translation_fun, ?TRANSLATE,
            {locale, {{NAME}}_util:get_language(Req)}],
    {ok, Body} = error_dtl:render([{code, integer_to_list(Code)},
                                   {message, Message}], Opts),
    cowboy_req:reply(Code, [{<<"Content-Type">>, <<"text/html">>}], Body, Req);

on_response(Code, _Headers, _Body, Req) ->
    lager:log(info, self(), "~p ~s ~s", [Code, cowboy_req:method(Req), cowboy_req:path(Req)]),
    Req.

listener_count() ->
    {{NAME}}_util:get_int_value("HTTP_LISTENER_COUNT", http_listener_count).

port() ->
    {{NAME}}_util:get_int_value("HTTP_PORT", http_port).

timeout() ->
    {{NAME}}_util:get_int_value("HTTP_TIMEOUT", http_timeout).
