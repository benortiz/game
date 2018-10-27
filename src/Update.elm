port module Update exposing (update)

import Messages exposing (Msg(..))
import Model exposing (Model)


port save : String -> Cmd msg



-- saveToStorage : Model -> ( Model, Cmd Msg )
-- saveToStorage model =
--     ( model, save (Model.encode 2 model) )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SpendPoints points ->
            ( { model | actionPoints = model.actionPoints - points }, Cmd.none )
