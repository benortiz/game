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
    , world : List Region
    }


type alias Location =
    ( Region, Place )


type alias Region =
    { name : String
    , area : Int
    , places : List Place
    }


type alias Place =
    { name : String
    , area : Int
    }


type Item
    = Tool String


defaultFarm =
    [ Place "Tent" 1, Place "Garden" 2 ]


defaultTown =
    [ Place "General Store" 4, Place "Post Office" 4, Place "Residential" 4 ]


world =
    [ Region "Farm" 16 defaultFarm
    , Region "Town" 32 defaultTown
    ]


findRegion : String -> List Region -> Region
findRegion regionName rlist =
    let
        foundRegion =
            List.head (List.filter (\e -> e.name == regionName) rlist)
    in
    Maybe.withDefault (Region "Nowhere" 0 []) foundRegion


findPlace : String -> List Place -> Place
findPlace placeName pworld =
    let
        foundPlace =
            List.head (List.filter (\p -> p.name == placeName) pworld)
    in
    Maybe.withDefault (Place "Nowhere" 0) foundPlace


placesInRegion : Region -> List Place
placesInRegion { places } =
    places


findLocation : String -> String -> List Region -> Location
findLocation regionName placeName regionList =
    let
        foundRegion =
            findRegion regionName regionList

        foundPlace =
            findPlace placeName (placesInRegion foundRegion)
    in
    ( foundRegion, foundPlace )


initial : Model
initial =
    { actionPoints = 18.0
    , location = findLocation "Farm" "Tent" world
    , money = 50.0
    , inventory = [ Tool "Shovel" ]
    , date = 0
    , world = world
    }



-- Update
-- port save : String -> Cmd msg
-- saveToStorage : Model -> ( Model, Cmd Msg )
-- saveToStorage model =
--     ( model, save (encode 2 model) )


type Msg
    = Goto Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Goto location ->
            ( { model
                | actionPoints = model.actionPoints - pointsBetweenLocations model.location location
                , location = location
              }
            , Cmd.none
            )


regionFromLocation : Location -> Region
regionFromLocation location =
    first location


placeFromLocation : Location -> Place
placeFromLocation location =
    second location


pointsBetweenLocations : Location -> Location -> Float
pointsBetweenLocations initialLocation finalLocation =
    if regionFromLocation initialLocation == regionFromLocation finalLocation then
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
        [ div [] [ text (regionN (regionFromLocation model.location)) ]
        , div [] [ text (String.fromFloat model.actionPoints) ]
        , button
            [ onClick (Goto (findLocation "Town" "General Store" model.world)) ]
            [ text "Go to General Store" ]
        ]


regionN : Region -> String
regionN { name } =
    name
