%% Copyright
-module(dali_backend).
-author("marcus").

%% API
-export([behaviour_info/1]).

-spec behaviour_info(atom()) -> 'undefined' | [{atom(), arity()}].
behaviour_info(callbacks) ->
  [ {init, 1},
    {visualize, 1}];
behaviour_info(_Other) ->
  undefined.

