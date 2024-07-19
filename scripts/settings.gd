extends Control

@onready var health_bar_checkbox = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/HealthBar

func _ready():
	if health_bar_checkbox:
		health_bar_checkbox.button_pressed = Global.show_health_bars
		health_bar_checkbox.connect("toggled", Callable(self, "_on_health_bar_toggled"))

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):  # "ui_cancel" is the default action for the "escape" key
		toggle_settings_visibility()

func _on_health_bar_toggled(checked):
	Global.show_health_bars = checked
	# Update all health bars in the scene
	for rock in get_tree().get_nodes_in_group("rocks"):
		rock.toggle_health_bar_visibility()

func toggle_settings_visibility():
	visible = not visible  # Toggle visibility of the settings
