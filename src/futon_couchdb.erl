%% Handle Futon requests dynamically

-module(futon_couchdb).
-author('Jason Smith <jhs@iriscouch.com>').

-include("couch_db.hrl").

-export([handle_futon_req/1]).

handle_futon_req(#httpd{}=Req) -> ok
    , ?LOG_DEBUG("Received Futon request:\n~p", [Req])
    , case code:priv_dir(?MODULE)
        of {error, bad_name} -> ok
            , ?LOG_DEBUG("Cannot find futon_couchdb priv dir", [])
            , old_futon(Req)
        ; Priv_dir -> ok
            , Mobile_dir = Priv_dir ++ "/mobilefuton"
            , case httpd_conf:is_directory(Mobile_dir)
                of {ok, Mobile_dir} -> ok
                    , mobile_enabled_futon(Req)
                ; Else -> ok
                    , ?LOG_DEBUG("Bad mobilefuton dir ~p: ~p", [Mobile_dir, Else])
                    , old_futon(Req)
                end
        end
    .

mobile_enabled_futon(Req) -> ok
    , ?LOG_DEBUG("Considering mobile futon", [])
    , old_futon(Req)
    .

old_futon(#httpd{}=Req) -> ok
    % XXX: For now, use the same config as favicon.ico.
    , case couch_config:get("httpd_global_handlers", "favicon.ico")
        of undefined -> ok
            , ?LOG_ERROR("Cannot find httpd_global_handlers/favicon.ico config", [])
            , send_500(Req, "We screwed up! Please email support@iriscouch.com and we will fix it ASAP")
        ; Favicon_cfg -> ok
            , case couch_util:parse_term(Favicon_cfg)
                of {ok, {Mod, Func, Futon_dir}} -> ok
                    , ?LOG_DEBUG("~p:~p ~p", [Mod, Func, Futon_dir])
                    , couch_httpd_misc_handlers:handle_utils_dir_req(Req, Futon_dir)
                ; _ -> ok
                    , ?LOG_ERROR("Bad favicon config: ~p", [Favicon_cfg])
                    , send_500(Req, "We screwed up! Please email support@iriscouch.com and we will fix it ASAP")
                end
        end
    .

send_500(Req) -> ok
    , send_500(Req, "not_implmented")
    .

send_500(Req, Msg) when is_list(Msg) -> ok
    , send_500(Req, list_to_binary(Msg))
    ;

send_500(Req, Msg) -> ok
    , couch_httpd:send_json(Req, 500, {[{error, Msg}]})
    .

% vim: sw=4 sts=4 et
