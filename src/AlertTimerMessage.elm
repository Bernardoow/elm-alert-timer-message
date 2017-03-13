module AlertTimerMessage exposing (Model, view, update, modelInit, Msg(..))

{-| Simple message alert library.
Its functionality is to hide and show alerts.
The module is given a time and an HTML structure then does the job.
You can create css and pass the msg to display.

# The model
@docs Model

# The initial state
@docs modelInit

# View
@docs view

# Msg
@docs Msg

# Update
@docs update

# The initial state
@docs modelInit
-}

import Html exposing (..)
import Html.Events exposing (..)
import Process
import Task
import Time exposing (Time)
import Dict exposing (Dict, values, empty, insert, size, toList, remove)
import List


--http://stackoverflow.com/questions/40599512/how-to-achieve-behavior-of-settimeout-in-elm


{-| Use Core Process to wait some seconds to hidden the alert.
-}
delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


{-| The model is simple. It's have a dict with msg and counter of displayed msg.
-}
type alias Model =
    { messages : Dict Int Message
    , count : Int
    }


{-| Empty model with counter 1
-}
modelInit : Model
modelInit =
    Model empty 1


init : ( Model, Cmd Msg )
init =
    ( modelInit, Cmd.none )


type alias Message =
    { message : Html Msg
    }


{-| The type representing messages that are passed inside the Rating.
    Notice: AddNewMessage receive two params: Float will be time to display and Html Msg will be a html struture.
        Tip: Use Css to improve Html Msg.
-}
type Msg
    = AddNewMessage Float (Html Msg)
    | RemoveAlert Int


{-| -}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddNewMessage seconds html ->
            let
                new_position =
                    model.count + 1

                novo =
                    insert new_position (Message html) model.messages

                newModel =
                    { model | messages = novo, count = new_position }
            in
                newModel ! [ delay (Time.second * seconds) <| RemoveAlert new_position ]

        RemoveAlert position ->
            let
                newDict =
                    remove position model.messages
            in
                { model | messages = newDict } ! []


{-| -}
view : Model -> Html Msg
view model =
    let
        list_of_messages =
            List.map (\item -> item.message) <|
                values (model.messages)
    in
        div []
            list_of_messages
