module Model exposing (Model, decode, encode, initial)

import Json.Decode as Decode
import Json.Encode as Encode


type alias Model =
    { actionPoints : Float
    }


initial : Model
initial =
    { actionPoints = 18.0
    }


decode : Decode.Decoder Model
decode =
    Decode.map Model
        (Decode.field "actionPoints" Decode.float)


encode : Int -> Model -> String
encode indent model =
    Encode.encode
        indent
        (Encode.object
            [ ( "actionPoints", Encode.float model.actionPoints )
            ]
        )
