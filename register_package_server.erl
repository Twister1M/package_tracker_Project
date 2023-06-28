-module(register_package_server).
-behaviour(gen_server).

-export([start_link/0,stop/0,register_package_for/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).



start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


stop() -> gen_server:call(?MODULE, stop).

% The stuff we change
register_package_for(PackageID,Location,Timestamp) -> 
    gen_server:call(?MODULE, {package,PackageID,Location,Timestamp}).


init([]) ->
    riakc_pb_socket:start_link("104.248.112.47", 8087).


handle_call({package,B_PackageID,B_Location,B_Timestamp}, _From, Riak_Pid) ->
    Request=riakc_obj:new(<<"Packages">>, B_PackageID, {B_Location, B_Timestamp}),
    {reply,riakc_pb_socket:put(Riak_Pid, Request),Riak_Pid};
handle_call(stop, _From, _State) ->
    {stop,normal,
                server_stopped,
        down.}.
% End of stuff we change

handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.