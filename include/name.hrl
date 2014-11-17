
-record(state, {languages}).

-define(DEFAULT_LANGUAGE, "en").

-define(MIME_TYPE_HTML, <<"text/html">>).
-define(MIME_TYPE_JSON, <<"application/json">>).

-define(STATUS_CODES, [{400, <<"Bad Request">>},
                       {401, <<"Unauthorized">>},
                       {402, <<"Payment Required">>},
                       {403, <<"Forbidden">>},
                       {404, <<"Not Found">>},
                       {405, <<"Method Not Allowed">>},
                       {406, <<"Not Acceptable">>},
                       {407, <<"Proxy Authentication Required">>},
                       {408, <<"Request Timeout">>},
                       {409, <<"Conflict">>},
                       {410, <<"Gone">>},
                       {411, <<"Length Required">>},
                       {412, <<"Precondition Failed">>},
                       {413, <<"Request Entity Too Large">>},
                       {414, <<"Request-URI Too Long">>},
                       {415, <<"Requested Range Not Satisfiable">>},
                       {417, <<"Expectation Failed">>},
                       {500, <<"Internal Server Error">>},
                       {501, <<"Not Implemented">>},
                       {502, <<"Bad Gateway">>},
                       {503, <<"Service Unavailable">>},
                       {504, <<"Gateway Timeout">>},
                       {505, <<"HTTP Version Not Supported">>}]).

-define(TRANSLATE, fun(Key, Locale) -> gettext:key2str(Key, Locale) end}).
