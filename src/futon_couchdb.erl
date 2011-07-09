%% Handle Futon requests dynamically

-module(futon_couchdb).
-author('Jason Smith <jhs@iriscouch.com>').

-export([handle_futon_req/1]).

-include("couch_db.hrl").

handle_futon_req(#httpd{}=Req) -> ok
    , ?LOG_DEBUG("Received Futon request:\n~p", [Req])
    , couch_httpd:send_json(Req, 500, {[{error, <<"not_implemented">>}]})
    .

% vim: sw=4 sts=4 et
