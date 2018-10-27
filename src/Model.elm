module Model exposing (Model, initial)

import Json.Decode as Decode
import Json.Encode as Encode


type alias Model =
    { actionPoints : Float
    , currentLocation : ( Region, Place )
    }


type Region
    = Farm
    | City


type Place
    = Building String
    | Field String


toName : Place -> String
toName placeType =
    case placeType of
        Building name ->
            name

        Field name ->
            name



-- decodeRegion : String -> Region
-- decodeRegion string =
--     case string of
--         "farm" ->
--             Farm
--         "city" ->
--             City
-- decodePlace : String -> String -> Place
-- decodePlace placeType name =
--     case placeType of
--         "building" ->
--             Building name
--         "field" ->
--             Field name


initial : Model
initial =
    { actionPoints = 18.0
    , currentLocation = ( Farm, Building "Tent" )
    }



-- decode : Decode.Decoder Model
-- decode =
--     Decode.map3
--         (\actionPoints currentRegion currentPlace ->
--             { initial
--                 | actionPoints = actionPoints
--                 , currentLocation = ( currentRegion, currentPlace )
--             }
--         )
--         (Decode.field "actionPoints" Decode.float)
--         (Decode.field "currentRegion" (Decode.map decodeRegion Decode.string))
--         (Decode.field "currentPlace" (place decodePlace Decode.string))
-- place : Decode.Decoder Place
-- place =
--     Decode.map2
--         (Decode.field "placeType" Decode.string)
--         (Decode.field "placeName" Decode.string)
-- encode : Int -> Model -> String
-- encode indent model =
--     Encode.encode
--         indent
--         (Encode.object
--             [ ( "actionPoints", Encode.float model.actionPoints )
--             ]
--         )
