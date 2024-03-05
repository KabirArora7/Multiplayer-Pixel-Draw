-- Your shapes go here
import Dict exposing (Dict)

myShapes localModel globalModel =
  [
    text "Pixel-Draw!!"
    |> centered
    |> size 12
    |> fixedwidth
    |> filled darkRed
    |> move(0,50)
    , renderTiles localModel globalModel
    |> move (0, -5)
    , renderColours localModel
    |> move (90, 0)
  
  ]

localUpdate : LocalMsg -> LocalModel -> GlobalModel -> LocalModel
localUpdate msg localModel globalModel = 
  case msg of
    Tick _ _ -> localModel
    PickColour colour -> { localModel | colour = colour }


-- Helper Function
paintTile (x,y) colour tiles = 
        Dict.update (x,y) (\_ -> Just colour) tiles



globalUpdate : GlobalMsg -> GlobalModel -> GlobalModel
globalUpdate msg globalModel =
    case msg of
        PaintTile (x,y) colour -> { globalModel | tiles = paintTile (x,y) colour globalModel.tiles }

              
        

initLocal : LocalModel
initLocal = { colour = RGB 255 0 0 }

initGlobal : GlobalModel
initGlobal = { tiles = Dict.empty }

-- Colours Defining
colours : List Colour
colours = [red, orange, yellow, green, blue, purple, pink]

-- Colours are not defined in Graphics SVG
cc (RGB r g b) = rgb (toFloat r) (toFloat g) (toFloat b)



red = RGB 255 0 0
orange = RGB 255 127 0
yellow = RGB 255 235 0
green = RGB 87 242 135
blue = RGB 0 90 255
purple = RGB 158 58 195
pink = RGB 243 90 145


renderColours localModel =
    group <|
        List.indexedMap (\n c ->
            group [ circle 5
              |> filled (cc c)
              |> addOutline (solid 0.5)
                (if localModel.colour == c then black else gray)
                  ] |> move(0,-12*(0.5 + toFloat n - 0.5 * toFloat (List.length colours)))
                    |> notifyTap (LocalMsg <| PickColour c)
                  ) colours

width = 18
height = 12
screenWidth = 144
screenHeight = 96
renderTiles localModel globalModel =
    let
      xList = List.range (-width // 2) (width//2)
      yList = List.range (-height // 2) (height//2)
      getColour (xx,yy) = case (Dict.get (xx,yy) globalModel.tiles) of
          Just c -> cc c
          _ -> white
    in
      group <|
        List.concat <|
          List.map (\ yy ->
            List.map (\xx ->
              square (screenWidth / width - 0.3)
                |> filled (getColour (xx,yy))
                |> addOutline (solid 0.3) gray
                |> move(toFloat xx*screenWidth / width,toFloat yy * screenHeight / height)
                |> notifyTap (GlobalMsg <| PaintTile (xx,yy) localModel.colour)
                )
              xList)
            yList




-- No need to edit the Code below
appConfig =
  simpleAppConfig
    { initLocal = initLocal
    , initGlobal = initGlobal
    , localUpdate = localUpdate
    , globalUpdate = globalUpdate
    , view = view
    , codecGlobalModel = JSON Codec.Encoders.encodeGlobalModel Codec.Decoders.decodeGlobalModel
    , codecGlobalMsg = JSON Codec.Encoders.encodeGlobalMsg Codec.Decoders.decodeGlobalMsg
    }

main : TEASyncGSVGAppWithTick () LocalModel GlobalModel LocalMsg GlobalMsg
main = 
  teaSyncAppSimpleWithTick Tick 
    appConfig

view : LocalModel -> GlobalModel -> { title: String, body : Collage (TEASync.Msg LocalMsg GlobalMsg GlobalModel) }
view localModel globalModel = 
  {
    title = "My App Title"
  , body = collage 192 128 (myShapes localModel globalModel)
  }
