extends Node2D


func _ready() -> void:
	# Spawn ghost
	var ghost := preload("res://characters/ghost.tscn").instantiate()
	var spawn_point: Node2D = %SpawnPoints.get_children().pick_random()
	ghost.global_position = spawn_point.global_position
	%World.add_child(ghost)
