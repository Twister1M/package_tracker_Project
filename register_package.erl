%% @doc A handler to store a new package in the database
-module(register_package).

-export([init/2]).

init(Req0, Opts) ->

    {ok,Data,_} = cowboy_req:read_body(Req0),
    [PackageID,Location,Timestamp|_] = jsx:decode(Data) %DECODE DATA HERE
    register_package_server:register_package_for(PackageID,Location,Timestamp), %STORE DATA HERE
    Req = cowboy_req:replay(200, #{
        <<"content-type">> => <<"text/json">>
    }, "[\"done\"]", Req0),
    {ok, Req, Opts}.
