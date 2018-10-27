module Game exposing (main)

import Browser
import Json.Decode as Decode
import Messages exposing (Msg(..))
import Model exposing (Model, decode, initial)
import Update exposing (update)
import View exposing (view)


main =
    Browser.element
        { init =
            \value ->
                ( value
                    |> Decode.decodeValue Model.decode
                    |> Result.withDefault Model.initial
                , Cmd.none
                )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
