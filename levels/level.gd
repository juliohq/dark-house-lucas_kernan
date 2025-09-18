extends Node2D


func _ready() -> void:
	var spawn_point: Node2D = %SpawnPoints.get_children().pick_random()
	%Ghost.global_position = spawn_point.global_position
