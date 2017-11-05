-module(consolidator).
-export([start/0, wait_msg/0]).


wait_msg() ->
    receive
        {consolidate, Content, Length} ->
            io:format(Content, []),
            wait_msg();
        true -> 
            io:format("ELSE\n", []);
    end,
    io:format("!!! HI", []).

start() ->
    register(consolidator, spawn(consolidator, wait_msg, [])).