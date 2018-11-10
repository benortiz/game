port module Game exposing (main)

import Browser
import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)
import Json.Encode exposing (Value)
import Tuple exposing (first, second)



-- Is there a more elm way of handling the 'world' and navigating within it?


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
    , world : World
    }


type alias Location =
    ( Geography, Geography )


type alias World =
    List Geography


type alias Geography =
    { name : String
    , area : Int
    , places : SubGeography
    }


type SubGeography
    = SubGeography (List Geography)


type Item
    = Tool String


emptySubGeography =
    SubGeography []


nowhere =
    Geography "Nowhere" 0 emptySubGeography


defaultFarm =
    [ Geography "Tent" 1 emptySubGeography, Geography "Garden" 2 emptySubGeography ]


defaultTown =
    [ Geography "General Store" 4 emptySubGeography, Geography "Post Office" 4 emptySubGeography, Geography "Residential" 4 emptySubGeography ]


world =
    [ Geography "Farm" 16 (SubGeography defaultFarm)
    , Geography "Town" 32 (SubGeography defaultTown)
    ]


initial : Model
initial =
    { actionPoints = 18.0
    , location = findLocation "Farm" "Tent" world
    , money = 50.0
    , inventory = [ Tool "Shovel" ]
    , date = 0
    , world = world
    }



-- Locations


geographyName : Geography -> String
geographyName { name } =
    name


unwrapSubGeography : SubGeography -> List Geography
unwrapSubGeography (SubGeography geographies) =
    geographies


regionFromLocation : Location -> Geography
regionFromLocation location =
    first location


placeFromLocation : Location -> Geography
placeFromLocation location =
    second location


placesInRegion : Geography -> SubGeography
placesInRegion { places } =
    places


otherRegions : Geography -> World -> List Geography
otherRegions primaryRegion allRegionsInWorld =
    List.filter (\r -> r /= primaryRegion) allRegionsInWorld


pointsBetweenLocations : Location -> Location -> Float
pointsBetweenLocations initialLocation finalLocation =
    if regionFromLocation initialLocation == regionFromLocation finalLocation then
        0.0

    else
        1.0


findRegion : String -> World -> Geography
findRegion regionName worldToFindRegionIn =
    let
        foundRegion =
            List.head (List.filter (\e -> e.name == regionName) worldToFindRegionIn)
    in
    Maybe.withDefault nowhere foundRegion


findPlace : String -> SubGeography -> Geography
findPlace placeName subGeoToFindPlaceIn =
    let
        foundPlace =
            List.head (List.filter (\p -> p.name == placeName) (unwrapSubGeography subGeoToFindPlaceIn))
    in
    Maybe.withDefault nowhere foundPlace


findLocation : String -> String -> World -> Location
findLocation regionName placeName worldToFindLocationIn =
    let
        foundRegion =
            findRegion regionName worldToFindLocationIn

        foundPlace =
            findPlace placeName (placesInRegion foundRegion)
    in
    ( foundRegion, foundPlace )



-- Update


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



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("Current region: " ++ geographyName (regionFromLocation model.location)) ]
        , div [] [ text ("Current place: " ++ geographyName (placeFromLocation model.location)) ]
        , div [] [ text ("Action points: " ++ String.fromFloat model.actionPoints) ]
        , h2 [] [ text "Regions" ]
        , renderOtherRegions model.location model.world
        , h2 [] [ text "Places" ]
        , renderPlacesAtLocation model.location model.world
        ]


renderOtherRegions : Location -> World -> Html Msg
renderOtherRegions locationToRenderRegions worldToExtractRegionsFrom =
    renderRegions
        (otherRegions (regionFromLocation locationToRenderRegions) worldToExtractRegionsFrom)
        worldToExtractRegionsFrom


renderRegions : List Geography -> World -> Html Msg
renderRegions regionsToRender worldToPassToRegionRenderer =
    div [] (List.map (\r -> renderRegion r worldToPassToRegionRenderer) regionsToRender)


renderRegion : Geography -> World -> Html Msg
renderRegion regionToRender worldToFindRegionIn =
    div []
        [ div [] [ text regionToRender.name ]
        , button
            [ onClick (Goto (findLocation regionToRender.name "" worldToFindRegionIn)) ]
            [ text ("Go to " ++ regionToRender.name) ]
        ]


renderPlacesAtLocation : Location -> World -> Html Msg
renderPlacesAtLocation locationToRenderPlaces worldToFindLocationIn =
    let
        region =
            regionFromLocation locationToRenderPlaces

        places =
            placesInRegion region
    in
    renderPlaces places region worldToFindLocationIn


renderPlaces : SubGeography -> Geography -> World -> Html Msg
renderPlaces placesToRender regionContainingPlaces worldToPassToPlaceRenderer =
    div []
        (List.map
            (\p -> renderPlace p regionContainingPlaces worldToPassToPlaceRenderer)
            (unwrapSubGeography placesToRender)
        )


renderPlace : Geography -> Geography -> World -> Html Msg
renderPlace placeToRender regionContainingPlace worldToFindPlaceIn =
    div []
        [ div [] [ text placeToRender.name ]
        , button
            [ onClick (Goto (findLocation regionContainingPlace.name placeToRender.name worldToFindPlaceIn)) ]
            [ text ("Go to " ++ placeToRender.name) ]
        ]
