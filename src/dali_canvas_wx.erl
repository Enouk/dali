%% Copyright
-module(dali_canvas_wx).
-author("marcus").

-behaviour(wx_object).

-export([start_link/1]).

%% gen_server
-export([init/1, handle_event/2, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-include_lib("wx/include/wx.hrl").

-record(state, {
  canvas :: wx:wx_object(),
  config :: list()
}).

start_link(Config) ->
  wx_object:start_link(?MODULE, Config, []).

init(Config) ->
  erlang:display({config, Config}),
  Env = proplists:get_value(env, Config),
  erlang:display({env, Env}),
  Parent = proplists:get_value(parent, Config),
  Size = proplists:get_value(size, Config),
  Opts = [{size, Size}, {style, ?wxSUNKEN_BORDER}],
  GLAtt = [{attribList, [?WX_GL_RGBA,
    ?WX_GL_DOUBLEBUFFER,
    ?WX_GL_MIN_RED, 8,
    ?WX_GL_MIN_GREEN, 8,
    ?WX_GL_MIN_BLUE, 8,
    ?WX_GL_DEPTH_SIZE, 24, 0]}],
  wx:set_env(Env),
  Canvas = wxGLCanvas:new(Parent, Opts ++ GLAtt),
  %% Connect to the events
  wxGLCanvas:connect(Canvas, size),
  wxWindow:hide(Parent),
  wxWindow:reparent(Canvas, Parent),
  wxWindow:show(Parent),
  wxGLCanvas:setCurrent(Canvas),
  dali_canvas:init(),
  {Parent, #state{canvas=Canvas, config=Config}}.

handle_event(#wx{event = #wxSize{size = {W, H}}}, State) ->
  case W =:= 0 orelse H =:= 0 of
    true -> skip;
    _ ->
      dali_canvas:resized(W,H),
      draw(State)
  end,
  {noreply, State}.

handle_call(_Request, _From, State) ->
  {noreply, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, State) ->
  catch wxGLCanvas:destroy(State#state.canvas).

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

draw(#state{canvas=Canvas}) ->
  dali_canvas:draw(),
  wxGLCanvas:swapBuffers(Canvas).
