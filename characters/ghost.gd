extends CharacterBody2D


const SPEED := 64


func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group(&"players")
	
	%Agent.target_position = player.global_position
	var next_position: Vector2 = %Agent.get_next_path_position()
	
	if %Agent.is_navigation_finished():
		velocity = Vector2()
	else:
		velocity = global_position.direction_to(next_position) * SPEED
	
	move_and_slide()


func _player_entered(_body: Node2D) -> void:
	Events.game_over.emit()
