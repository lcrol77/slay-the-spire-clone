extends CardState

func enter():
	card_ui.color.color = Color.ORANGE
	card_ui.state.text = "CLIKED"
	card_ui.drop_point_detector.monitoring = true

func on_input(event: InputEvent):
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
