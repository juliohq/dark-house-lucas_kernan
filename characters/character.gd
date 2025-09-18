extends CharacterBody2D


## How fast the character will move around.
const MOVEMENT_SPEED := 128
const RUN_SPEED := 192
const STAMINA := 10.0
const STAMINA_RECOVER := 3.0

@export var animator: AnimationPlayer

## The direction the character is moving to.
var direction := Vector2()
## The direction the character is facing to.
var facing := Vector2.DOWN
## The amount of stamina left.
var stamina := STAMINA
## The timer that controls when stamina should recover.
var stamina_recover := STAMINA_RECOVER


func _physics_process(delta: float) -> void:
	# Process character movement
	if Input.is_action_pressed(&"run") and stamina > 0.0:
		velocity = direction * RUN_SPEED
		stamina -= delta
		stamina_recover = STAMINA_RECOVER
	else:
		velocity = direction * MOVEMENT_SPEED
		
		if stamina_recover > 0.0:
			stamina_recover -= delta
		else:
			stamina += delta
	
	Events.stamina_changed.emit(stamina / STAMINA)
	
	# Set facing direction
	if direction:
		facing = direction
	
	# Perform the actual movement
	move_and_slide()


## Plays the given animation based on the direction of the character.
func play_animation(left: StringName, right: StringName, up: StringName, down: StringName) -> void:
	var direction_index = posmod(int(snappedf(facing.angle(), (PI / 2.0)) / (PI / 2.0)), 4)
	animator.play([right, down, left, up][direction_index])
