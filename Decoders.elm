import Json.Decode as Decode exposing (..)
import Types exposing(..)
import TEASync.Codec.Decoders exposing(..)

decodeColour : (Decoder Colour)
decodeColour  =
  field "tag" string |> andThen
    (\tag -> case tag of
      "RGB" -> map3 RGB (at ["f1"] (int)) (at ["f2"] (int)) (at ["f3"] (int))
      _ -> fail "Invalid tag"
    )

decodeGlobalModel : (Decoder GlobalModel)
decodeGlobalModel  =
    map GlobalModel (at ["tiles"] (decodeDict ((decodeTuple2 (int) (int))) (decodeColour)))

decodeGlobalMsg : (Decoder GlobalMsg)
decodeGlobalMsg  =
  field "tag" string |> andThen
    (\tag -> case tag of
      "PaintTile" -> map2 PaintTile (at ["f1"] ((decodeTuple2 (int) (int)))) (at ["f2"] (decodeColour))
      _ -> fail "Invalid tag"
    )

