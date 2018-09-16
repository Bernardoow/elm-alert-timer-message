module Basic exposing (Model, Msg(..), initial, main, subscriptions, update, view)

import AlertTimerMessage exposing (Msg)
import Browser
import Html exposing (..)
import Html.Events exposing (..)


type Msg
    = AlertTimer AlertTimerMessage.Msg
    | AddNewMessage Float


type alias Model =
    { alert_messages : AlertTimerMessage.Model }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick <| AddNewMessage 5 ] [ text "5 s" ]
        , button [ onClick <| AddNewMessage 2 ] [ text "2 s" ]
        , Html.map AlertTimer (AlertTimerMessage.view model.alert_messages)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlertTimer alertTimeMsg ->
            let
                ( updateModel, subCmd ) =
                    AlertTimerMessage.update alertTimeMsg model.alert_messages
            in
            ( { model | alert_messages = updateModel }
            , Cmd.map AlertTimer subCmd
            )

        AddNewMessage time ->
            let
                newMsg =
                    AlertTimerMessage.AddNewMessage time <| div [] [ text "MSG Teste" ]

                ( updateModel, subCmd ) =
                    AlertTimerMessage.update newMsg model.alert_messages
            in
            ( { model | alert_messages = updateModel }
            , Cmd.map AlertTimer subCmd
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initial : () -> ( Model, Cmd Msg )
initial _ =
    ( Model AlertTimerMessage.modelInit, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = initial
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
