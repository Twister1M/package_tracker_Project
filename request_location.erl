%% @doc A handler to deal with retrieval of the location
%% for a specific package.
-module(get_friends).

-export([init/2]).

init(Req0, Opts) ->
	{ok,Data,_} = cowboy_req:read_body(Req0),
	%it is expected that the data consists of one quoted-string name
	%in an array.
	[PackageID|_] = jsx:decode(Data),
	Location = jsx:encode(get_location_server:get_location_of(Package)),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/json">>
	}, Location, Req0),
	{ok, Req, Opts}.