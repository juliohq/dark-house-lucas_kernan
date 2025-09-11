extends Node


## The default path for the settings file.
const SETTINGS_PATH := "user://settings.dat"
## The default path for the save file.
const SAVE_PATH := "user://save.dat"
## The version of the same file. (for backward compatibility)
const SAVE_VERSION := 1

## The current language code.
var language := "en"


func _ready() -> void:
	randomize()
	load_settings(SETTINGS_PATH)
	set_process_unhandled_input(OS.is_debug_build())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().quit()


## Saves the game settings.
func save_settings(filename: String) -> void:
	var f := FileAccess.open(filename, FileAccess.WRITE)
	var err := f.get_error()
	
	if err == OK:
		# Save language
		f.store_var(language)
		
		# Save difficulty mode
		push_warning("Difficulty save logic isn't implemented")
		
		# Save window fullscreen mode
		f.store_var(get_window().mode == Window.MODE_FULLSCREEN)
		
		# Save audio buses volumes
		var buses = []
		
		for bus in AudioServer.bus_count:
			buses.append(AudioServer.get_bus_volume_linear(bus))
		
		f.store_var(buses)
		
		# Save input map
		var input_map := {}
		
		for action: StringName in InputMap.get_actions():
			if action.begins_with("ui_"):
				continue
			
			var events = InputMap.action_get_events(action)
			input_map[action] = var_to_str(events)
		
		f.store_var(input_map)
	else:
		push_error("Failed to save file to %s (error %d)" % [filename, err])


## Loads the game settings.
func load_settings(filename: String) -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var f := FileAccess.open(filename, FileAccess.READ)
		var err := f.get_error()
		
		if err == OK:
			# Read language
			language = f.get_var()
			TranslationServer.set_locale(language)
			
			# Read difficulty mode
			push_warning("Difficulty load logic isn't implemented")
			
			# Read window fullscreen mode
			get_window().mode = Window.MODE_FULLSCREEN if f.get_var() else Window.MODE_WINDOWED
			
			# Read audio buses volumes
			var bus := 0
			
			for volume: float in f.get_var():
				AudioServer.set_bus_volume_linear(bus, volume)
				bus += 1
			
			# Read input map
			var input_map: Dictionary = f.get_var()
			
			for action: StringName in input_map:
				InputMap.action_erase_events(action)
				
				for event: InputEvent in str_to_var(input_map[action]):
					InputMap.action_add_event(action, event)
		else:
			push_error("Failed to load file from %s (error %d)" % [filename, err])
