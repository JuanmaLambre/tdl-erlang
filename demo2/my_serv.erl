-module(my_serv).
-behaviour(gen_server).

-export([start/0, stop/0, ping/0, echo/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).

start() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop).

ping() ->
    gen_server:call(?MODULE, {ping}).

echo(Message) ->
    gen_server:call(?MODULE, {echo, Message}).


init([]) ->
    {ok, ets:new(?MODULE, [])}.

handle_call({ping}, _From, State) ->
    Reply = "Pong!",
    {reply, Reply, State};

handle_call({echo, Message}, _From, State) ->
    {reply, Message, State}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.
