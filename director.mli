(* Initiates the main game loop *)
val update_loop : Dom_html.canvasElement
                  -> (Object.collidable * Object.collidable list)
                  -> float*float
                  -> unit

(* Keydown event handler function *)
val keydown : Dom_html.keyboardEvent -> Js.boolean

(* Keyup event handler function *)
val keyup : Dom_html.keyboardEvent -> Js.boolean
