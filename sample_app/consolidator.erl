-module(consolidator).
-export([start/0, wait_msg/1]).

-define(CONSOLIDATING_DIR, "/tmp/sample_app/consolidating/").
-define(DONE_DIR, "/tmp/sample_app/done/").
-define(MIN_SIZE, 1*1024*1024).


now_timestamp() ->
    {_, _, Milis} = os:timestamp(),
    {{Year,Month,Day},{Hour,Minute,Second}} = erlang:localtime(),
    io_lib:format("~4w~2..0w~2..0w~2..0w~2..0w~2..0w~6..0w", [Year, Month, Day, Hour, Minute, Second, Milis]).

process_content(Content) ->
    <<Content/binary, "\n">>.

wait_msg(Current) ->
    receive
        {consolidate, Content, Length} ->
            file:write_file(?CONSOLIDATING_DIR ++ Current, process_content(Content), [append]),
            case filelib:file_size(?CONSOLIDATING_DIR ++ Current) >= ?MIN_SIZE of 
                true ->
                    file:rename(?CONSOLIDATING_DIR ++ Current, ?DONE_DIR ++ Current),
                    wait_msg(now_timestamp());
                false ->
                    wait_msg(Current)
            end;
        ping ->
            io:format("\nPONG!\n", []),
            wait_msg(Current)
    end.

start() ->
    register(consolidator, spawn(consolidator, wait_msg, [now_timestamp()])).