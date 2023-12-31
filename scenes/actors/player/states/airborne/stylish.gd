class_name Stylish
extends PlayerState
## Stylish cheer after a move.


func _cycle_tick():
	movement.decelerate("ground")


func _tell_switch():
	if not actor.doll.is_playing():
		return &"Idle"

	if input_direction != 0:
		return &"Walk"

	if (input.buffered_input(&"spin") and movement.can_spin()):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	return &""