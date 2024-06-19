class_name Crouch
extends PlayerState
## Holding down on the floor.


# The first entry in the array is wether the first frame
# of the crouch animation should be skipped or not,
# the second entry is wether the crouch sound effect should be played or not.
func _on_enter(array):
	if array[0] == true:
		actor.doll.set_frame(1)

	if array[1] == true:
		for sfx_list in sfx_layers:
			sfx_list.play_sfx_at(self)


func _physics_tick():
	movement.update_direction(InputManager.get_x_dir())
	movement.decelerate(0.07)


## Return whether or not you can crouchwalk.
func _can_crouchwalk() -> bool:
	return (
		actor.vel.x == 0
		and InputManager.is_moving_x()
		and not actor.test_move(actor.transform, Vector2(0.1 * movement.facing_direction, 0))
	)


func _trans_rules():
	if movement.is_slide_slope():
		return &"ButtSlide"

	if _can_crouchwalk():
		return &"Waddle"

	if input.buffered_input(&"spin"):
		return &"Breakdance"

	if not actor.crouchlock.enabled and input.buffered_input(&"jump"):
		if actor.vel.x == 0:
			return &"Backflip"
		else:
			return &"Longjump"

	if not Input.is_action_pressed(&"down") and not actor.crouchlock.enabled:
		return &"Idle"

	return &""