extends CanvasLayer


const TIME := 120.0

var time := TIME


func _ready() -> void:
	Events.game_finished.connect(_game_finished)
	Events.game_over.connect(_game_over)


func _process(delta: float) -> void:
	time -= delta
	
	if time <= 0.0:
		time = 0.0
		Events.game_finished.emit()
	
	%TimeLeft.text = "%.1f" % time


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		add_child(preload("res://ui/pause.tscn").instantiate())


func _game_finished() -> void:
	add_child(preload("res://ui/game_over.tscn").instantiate())


func _game_over() -> void:
	add_child(preload("res://ui/game_over.tscn").instantiate())
