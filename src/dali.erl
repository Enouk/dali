%% Copyright
-module(dali).
-author("marcus").

%% API
-export([start/0, stop/0, new_window/1]).

start() ->
  application:start(dali).

stop() ->
  application:stop(dali).

new_window(_Name) ->
  dali_server:new_window([]).

