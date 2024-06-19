class_name Walljump
extends PlayerState
## Jumping from a wallslide.

@export var jump_power: float = 8.15
## How much the walljump sends you forwards.
@export var push_power: float = 3

## The y position of the point you walljumped from.
## Used to avoid being able to scale a wall infinitely with a spin.
var start_y: float
## How many extra units get subtracted from the start_y position to
## avoid being able to scale a wall infinitely with a spin.
## Currently set to roughly the amount of height you can from a spin
var extra_sub: float = 10.0


## Direction is the direction in which the walljump sends you.
## By default, it sends you in the opposite of your facing direction,
## but for cases like the spinjump; this needs to be handled manually.
## Direction is an integer type.
func _on_enter(direction):
	start_y = actor.position.y

	movement.update_direction(direction)
	movement.activate_freefall_timer()

	actor.vel.y = -jump_power
	actor.vel.x = push_power * direction

	movement.consec_jumps = 1


func _physics_tick():
	var should_flip: bool

	should_flip = actor.position.y > start_y + extra_sub

	if InputManager.get_x_dir() != movement.facing_direction:
		movement.move_x(0.13, should_flip)
	elif InputManager.is_moving_x():
		movement.move_x("air", should_flip)

	movement.apply_gravity(-actor.vel.y / jump_power)
	movement.decelerate(0.01)


func _trans_rules():
	if input.buffered_input(&"spin"):
		return &"Spin"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", actor.vel.x]
		else:
			return [&"Dive", false]

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_init_wallslide(true):
		return &"Wallslide"

	if actor.push_rays.is_colliding() and input.buffered_input(&"jump"):
		reset_state(-movement.facing_direction)

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""