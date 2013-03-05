%% Copyright
-module(dali_canvas).
-author("marcus").

%% API
-export([init/0, resized/2, draw/0]).

-include_lib("wx/include/gl.hrl").
-include_lib("wx/include/glu.hrl").

init() ->
  gl:shadeModel(?GL_SMOOTH),
  gl:clearColor(1.0, 0.0, 0.0, 0.0),
  gl:clearDepth(1.0),
  gl:enable(?GL_DEPTH_TEST),
  gl:depthFunc(?GL_LEQUAL),
  gl:hint(?GL_PERSPECTIVE_CORRECTION_HINT, ?GL_NICEST),
  ok.

resized(W, H) ->
  gl:viewport(0, 0, W, H),
  gl:matrixMode(?GL_PROJECTION),
  gl:loadIdentity(),
  glu:perspective(45.0, W / H, 0.1, 100.0),
  gl:matrixMode(?GL_MODELVIEW),
  gl:loadIdentity().

draw() ->
  gl:clear(?GL_COLOR_BUFFER_BIT bor ?GL_DEPTH_BUFFER_BIT),
  gl:loadIdentity(),
  ok.