extends CharacterBody2D


## How fast the character will move around.
const MOVEMENT_SPEED := 128
const RUN_SPEED := 192

@export var animator: AnimationPlayer

## The direction the character is moving to.
var direction := Vector2()
## The direction the character is facing to.
var facing := Vector2.DOWN


func _physics_process(_delta: float) -> void:
	# Process character movement
	if Input.is_action_pressed(&"run"):
		velocity = direction * RUN_SPEED
	else:
		velocity = direction * MOVEMENT_SPEED
	
	# Set facing direction
	if direction:
		facing = direction
	
	# Perform the actual movement
	move_and_slide()


## Plays the given animation based on the direction of the character.
func play_animation(left: StringName, right: StringName, up: StringName, down: StringName) -> void:
	var direction_index = posmod(int(snappedf(facing.angle(), (PI / 2.0)) / (PI / 2.0)), 4)
	animator.play([right, down, left, up][direction_index])
