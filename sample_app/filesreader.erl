-module(filesreader).
-export([start/0, read_file/1]).

-define(INPUT_DIR, "/tmp/sample_app/input/").
-define(PROCESS_DIR, "/tmp/sample_app/process/").


read_file(Filename) ->
    Content = element(2, file:read_file(?PROCESS_DIR ++ Filename)),
    {consolidator, consolidator@juanma} ! {consolidate, Content, length(Content)}.

deliver_files() ->
    timer:sleep(1000),
    Files = filelib:wildcard(?INPUT_DIR ++ "*"),
    if length(Files) == 0 -> 
        deliver_files();
    true ->
        Filenames = lists:map(fun(F) -> lists:last(string:tokens(F, "/")) end, Files),
        lists:foreach(fun(F) ->
                file:rename(?INPUT_DIR ++ F, ?PROCESS_DIR ++ F),
                spawn(?MODULE, read_file, [F])
            end, Filenames),
        deliver_files()
    end.


start() ->
    deliver_files().