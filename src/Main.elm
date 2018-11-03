port module Game exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Encode exposing (Value)
import Tuple exposing (first, second)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Value -> ( Model, Cmd msg )
init flags =
    ( initial
    , Cmd.none
    )



-- Model


type alias Model =
    { actionPoints : Float
    , location : Location
    , money : Float
    , inventory : List Item
    , date : Int
    }


type alias Location =
    ( Geography, Geography )


type alias Geography =
    { name : String
    , area : Int
    }


type Item
    = Tool String


initial : Model
initial =
    { actionPoints = 18.0
    , location = ( Geography "Farm 1" 16, Geography "Tent" 1 )
    , money = 50.0
    , inventory = [ Tool "Shovel" ]
    , date = 0
    }



-- Update


port save : String -> Cmd msg



-- saveToStorage : Model -> ( Model, Cmd Msg )
-- saveToStorage model =
--     ( model, save (encode 2 model) )


type Msg
    = SpendPoints Float
    | Goto Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SpendPoints points ->
            ( { model | actionPoints = model.actionPoints - points }, Cmd.none )

        Goto location ->
            ( { model
                | actionPoints = model.actionPoints - pointsBetweenLocations model.location location
                , location = location
              }
            , Cmd.none
            )


region : Location -> Geography
region location =
    first location


pointsBetweenLocations : Location -> Location -> Float
pointsBetweenLocations initialLocation finalLocation =
    if region initialLocation == region finalLocation then
        0.0

    else
        1.0



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (geographyName (region model.location)) ]
        , button
            [ onClick (SpendPoints 0.5) ]
            [ text "Spend" ]
        ]


geographyName : Geography -> String
geographyName { name } =
    name
