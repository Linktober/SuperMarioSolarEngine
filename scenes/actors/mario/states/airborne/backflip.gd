class_name Backflip
extends PlayerState
## Jumping while crouching.


const PUSH_POWER: float = 1.4
const JUMP_POWER: float = 9.1


func _on_enter(_handover):
	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * -movement.facing_direction


func _cycle_tick():
	if input_direction != movement.facing_direction:
		movement.move_x(0.04, false)
	elif input_direction != 0:
		movement.move_x(0.07, false)


func _post_tick():
	movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func _tell_switch():
	if actor.is_on_floor():
		return &"BackflipStyle"

	if movement.can_wallslide():
		return &"Wallslide"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
