module Game exposing (main)

import Browser
import Json.Encode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model, initial)
import Update exposing (update)
import View exposing (view)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Value -> ( Model, Cmd msg )
init flags =
    ( Model.initial
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
