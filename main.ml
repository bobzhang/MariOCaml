[@@@bs.config{no_export}]
open Actors
open Sprite
open Object
module Html = Dom_html
module Pg = Procedural_generator

let loadCount =  ref 0
let imgsToLoad = 4
let level_width = 2400.
let level_height = 256.

(*Canvas is chosen from the index.html file. The context is obtained from
 *the canvas. Listeners are added. A level is generated and the general
 *update_loop method is called to make the level playable.*)
let load _ =
  (* Random.self_init(); *)
  let canvas_id = "canvas" in
  let canvas = match Dom_html.getElementById Dom_html.document canvas_id with
    | None ->
    (*Printf.printf "cant find canvas %s \n" canvas_id;*)
      Js.log {j|can find canvas $canvas_id|j};
      failwith "fail"
    | Some el -> Dom_html.elementToCanvasElement el
  in
  let context = (Dom_html.canvasElementToJsObj canvas)##getContext "2d" in
  let _ = Dom_html.addEventListener Dom_html.document "keydown" (Director.keydown) Js.true_ in
  let _ = Dom_html.addEventListener Dom_html.document "keyup" (Director.keyup) Js.true_ in
  let () = Pg.init () in
  let _ = Director.update_loop canvas (Pg.generate level_width level_height context) (level_width,level_height) in
  print_endline "asd";
  ()

let inc_counter _ =
  loadCount := !loadCount + 1;
  if !loadCount = imgsToLoad then load() else ()

(*Used for concurrency issues.*)
let preload _ =
  let root_dir = "sprites/" in
  let imgs = [ "blocks.png";"items.png";"enemies.png";"mario-small.png" ] in
  List.map (fun img_src ->
    let img_src = root_dir ^ img_src in
    let img = (Html.createImg Dom_html.document) in
    (Dom_html.imageElementToJsObj img)##src #= (img_src) ;
    ignore(Dom_html.addEventListenerImg  img "load"
    ( (fun ev ->  inc_counter(); Js.true_)) Js.true_)) imgs


let _ = (Dom_html.windowToJsObj Dom_html.window)##onload #= (fun _ -> ignore (preload()); Js.true_)
