%% Copyright
-module(dali_server).
-author("marcus").

-behaviour(gen_server).

%% API
-export([start_link/0, new_window/1, close_window/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-record(state, {
  backend=dali_backend_wx :: atom(),
  backend_state :: any()
}).

%% API
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_window(Options) ->
   gen_server:call(?MODULE, {new_window, Options}).

close_window(Id) ->
  gen_server:call(?MODULE, {close_window, Id}).

%% gen_server callbacks
init(_Args) ->
  S = #state{},
  Backend = S#state.backend,
  {ok, BackendState} = Backend:init([]),
  S2 = S#state{backend_state = BackendState},
  {ok, S2}.

handle_call({new_window, _Options}, _From, #state{backend=Backend, backend_state=BackendState} = S) ->
  {ok, _Ref} = Backend:new_window([], BackendState),
  {reply, ok, S};

handle_call({close_window, _Options}, _From, State) ->
  {reply, ok, State};

handle_call(_Request, _From, State) ->
  {noreply, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, S) ->
  Backend = S#state.backend,
  BackendState = S#state.backend_state,
  Backend:close(BackendState),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
