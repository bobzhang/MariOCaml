open Object
open Sprite
module Html = Dom_html
let document = Html.document

let get_context canvas = canvas##getContext "2d"

let render_bbox sprite (posx,posy) =
  let context = Dom_html.canvasRenderingContext2DToJsObj sprite.context in
  let (bbox,bboy) = sprite.params.bbox_offset in
  let (bbsx,bbsy) = sprite.params.bbox_size in
  context##strokeStyle #= "#FF0000";
  context##strokeRect (posx+.bbox) (posy+.bboy) bbsx bbsy

(*Draws a sprite onto the canvas.*)
let render sprite (posx,posy) =
  let context = Dom_html.canvasRenderingContext2DToJsObj sprite.context in
  let (sx, sy) = sprite.params.src_offset in
  let (sw, sh) = sprite.params.frame_size in
  let (dx, dy) = (posx,posy) in
  let (dw, dh) = sprite.params.frame_size in
  let sx = sx +. (float_of_int !(sprite.frame)) *. sw in
  (*print_endline (string_of_int !(sprite.frame));*)
  (*context##clearRect(0.,0.,sw, sh);*)
  context##drawImage sprite.img sx sy sw sh dx dy dw dh

(*Draws two background images, which needs to be done because of the
 *constantly changing viewport, which is always at most going to be
 *between two background images.*)
let draw_bgd bgd off_x =
  render bgd (~-.off_x,0.);
  render bgd ((fst bgd.params.frame_size) -. off_x, 0.)

(*Used for animation updating. Canvas is cleared each frame and redrawn.*)
let clear_canvas canvas =
  let canvas = Dom_html.canvasElementToJsObj canvas in
  let context = Dom_html.canvasRenderingContext2DToJsObj (canvas##getContext "2d") in
  let cwidth = float_of_int canvas##width in
  let cheight = float_of_int canvas##height in
  ignore @@ context##clearRect 0. 0. cwidth cheight

(*Displays the text for score and coins.*)
let hud canvas score coins =
  let score_string = string_of_int score in
  let coin_string = string_of_int coins in
  let canvas = Dom_html.canvasElementToJsObj canvas in
  let context = Dom_html.canvasRenderingContext2DToJsObj (canvas##getContext "2d") in
  ignore @@ context##font #= ( ("10px 'Press Start 2P'"));
  ignore @@ context##fillText  ("Score: "^score_string) ((float_of_int canvas##width) -. 140.) 18.;
  ignore @@ context##fillText  ("Coins: "^coin_string) 120. 18.

(*Displays the fps.*)
let fps canvas fps_val =
  let fps_str = int_of_float fps_val |> string_of_int in
  let canvas = Dom_html.canvasElementToJsObj canvas in
  let context = Dom_html.canvasRenderingContext2DToJsObj (canvas##getContext "2d") in
  ignore @@ context##fillText fps_str 10. 18.

(*game_win displays a black screen when you finish a game.*)
let game_win ctx =
  let ctx = Dom_html.canvasRenderingContext2DToJsObj ctx in
  ctx##rect 0. 0. 512. 512.;
  ctx##fillStyle #= ( "black");
  ctx##fill ();
  ctx##fillStyle #= ( "white");
  ctx##font #= ( "20px 'Press Start 2P'");
  ctx##fillText ("You win!") 180. 128.;
  failwith "Game over."

(*gave_loss displays a black screen stating a loss to finish that level play.*)
let game_loss ctx =
  let ctx = Dom_html.canvasRenderingContext2DToJsObj ctx in
  ctx##rect 0. 0. 512. 512.;
  ctx##fillStyle #= ( "black");
  ctx##fill ();
  ctx##fillStyle #= ( "white");
  ctx##font #= ( "20px 'Press Start 2P'");
  ctx##fillText ( "GAME OVER. You lose!") 60. 128.;
  failwith "Game over."

let draw_background_color canvas = failwith "todo"

