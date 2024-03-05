import GraphicSVG.EllieApp exposing(GetKeyState)
import Dict exposing (Dict)

{-
The following types are required for TEASync to function:
- LocalMsg
- GlobalMsg
- LocalModel
- GlobalModel

-}
type LocalMsg 
    = Tick Float GetKeyState
    | PickColour Colour

type alias LocalModel = 
    { colour : Colour
    }

type GlobalMsg
  =  PaintTile (Int, Int) Colour
  
type Colour = RGB Int Int Int

type alias GlobalModel = 
    {  tiles : Dict (Int, Int) Colour
    }
    

