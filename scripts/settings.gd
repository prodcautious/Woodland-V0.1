extends Control
func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):  # "ui_cancel" is the default action for the "escape" key
		toggle_settings_visibility()

func toggle_settings_visibility():
	visible = not visible  # Toggle visibility of the settings
