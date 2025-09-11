extends CharacterBody2D


const SPEED := 64


func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group(&"players")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()


func _player_entered(_body: Node2D) -> void:
	Events.game_over.emit()
