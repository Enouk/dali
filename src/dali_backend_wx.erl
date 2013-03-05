%% Copyright
-module(dali_backend_wx).
-author("marcus").

-behaviour(dali_backend).

%% API
-export([init/1, close/1, visualize/1, new_window/2, close_window/2]).

-include_lib("wx/include/wx.hrl").

init(_Options) ->
  _WxObject = wx:new(),
  {ok, wx:get_env()}.

close(_WxEnv) ->
  wx:destroy().

visualize(_Arg) ->
  ok.

new_window(_Id, WxEnv) ->
  erlang:display({wx, WxEnv}),
  Size = {size, {300, 300}},
  Frame = wxFrame:new(wx:null(), ?wxID_ANY, "MyFrame", [Size]),
  wxFrame:show(Frame),
  Config = [{parent, Frame}, {env, WxEnv}, Size],
  Ref = dali_canvas_wx:start_link(Config),
  {ok, Ref}.

close_window(Id, _wxObject) ->
  wxWindow:close(Id).
