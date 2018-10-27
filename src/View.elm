module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Model exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (String.fromFloat model.actionPoints) ]
        , button
            [ onClick (SpendPoints 0.5) ]
            [ text "Spend" ]
        ]
