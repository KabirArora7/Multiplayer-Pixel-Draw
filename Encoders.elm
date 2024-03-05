import Json.Encode as Encode exposing (..)
import Types exposing(..)
import TEASync.Codec.Encoders exposing(..)

encodeColour : (Colour -> Value)
encodeColour value =
  case value of
    RGB f1 f2 f3 -> Encode.object [("tag", string "RGB"),("f1", int f1),("f2", int f2),("f3", int f3)]

encodeGlobalModel : (GlobalModel -> Value)
encodeGlobalModel =
    (\value1 -> Encode.object [("tiles", encodeDict (encodeTuple2 int int) (encodeColour) value1.tiles)])

encodeGlobalMsg : (GlobalMsg -> Value)
encodeGlobalMsg value =
  case value of
    PaintTile f1 f2 -> Encode.object [("tag", string "PaintTile"),("f1", encodeTuple2 int int f1),("f2", encodeColour f2)]

