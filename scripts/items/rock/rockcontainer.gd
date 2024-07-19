extends Node2D

# Exported variables
@export var sprite: Sprite2D
@export var outline_color: Color = Color(0.929, 0.929, 0.875, 1)  # #ededdf
@export var break_time: float = 0.5  # Time in seconds between hits
@export var max_hp: int = 3  # Maximum health points
@export var hp: int = 3  # Current HP

# Onready variables
@onready var health_bar = $Rock/HealthBar
@onready var hit_sound = $HitSound
@onready var break_sound = $BreakSound

# Other variables
var unique_material: ShaderMaterial
var can_hit: bool = true  # Variable to control if the rock can be hit
var health_bar_visible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("rocks")
	initialize_health()
	create_unique_material()
	connect_signals()
	setup_break_timer()
	hide_health_bar()  # Ensure health bar is hidden initially

# Initialize health bar values
func initialize_health():
	hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = hp

# Create a unique material for this instance
func create_unique_material():
	if $Rock.material:
		unique_material = $Rock.material.duplicate() as ShaderMaterial
		unique_material.shader = $Rock.material.shader  # Ensure the shader is also copied
		$Rock.material = unique_material

# Connect signals to the appropriate functions
func connect_signals():
	$Rock/Area2D.connect("mouse_entered", Callable(self, "_on_Area2D_mouse_entered"))
	$Rock/Area2D.connect("mouse_exited", Callable(self, "_on_Area2D_mouse_exited"))
	$Rock/Area2D.connect("input_event", Callable(self, "_on_Area2D_input_event"))
	$Rock/BreakTimer.connect("timeout", Callable(self, "_on_BreakTimer_timeout"))

# Setup the break timer
func setup_break_timer():
	$Rock/BreakTimer.wait_time = break_time
	$Rock/BreakTimer.one_shot = true  # Ensure the timer only runs once per click

# Show outline when mouse enters the area
func _on_Area2D_mouse_entered():
	show_outline()

# Hide outline when mouse exits the area
func _on_Area2D_mouse_exited():
	hide_outline()

# Handle input events
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_hit()

# Handle the hit action
func handle_hit():
	if can_hit:
		can_hit = false
		health_bar_visible = true  # Show health bar on hit
		toggle_health_bar_visibility()
		play_hit_animation()
		play_hit_sound()
		update_health()
		start_break_timer()

# Play the hit animation
func play_hit_animation():
	$Rock/AnimationPlayer.play("shake")

# Play the hit sound with random pitch
func play_hit_sound():
	if hit_sound:
		hit_sound.pitch_scale = randf_range(0.8, 1.2)
		hit_sound.play()

# Update the health value and the health bar
func update_health():
	hp -= 1
	update_health_bar()

# Start the break timer
func start_break_timer():
	$Rock/BreakTimer.start()

# Handle the timeout of the break timer
func _on_BreakTimer_timeout():
	can_hit = true  # Re-enable hitting after the timer finishes

# Update the health bar
func update_health_bar():
	health_bar.value = hp
	if hp <= 0:
		handle_rock_destruction()

# Handle rock destruction
func handle_rock_destruction():
	health_bar.value = 0
	print("Rock destroyed")  # Add more logic for when the rock is destroyed
	break_sound.play()
	$Rock.queue_free()

# Show the outline by enabling the shader parameter
func show_outline():
	if unique_material:
		unique_material.set_shader_parameter("outline_enabled", true)
		unique_material.set_shader_parameter("outline_color", outline_color)

# Hide the outline by disabling the shader parameter
func hide_outline():
	if unique_material:
		unique_material.set_shader_parameter("outline_enabled", false)

# Toggle health bar visibility based on global setting
func toggle_health_bar_visibility():
	health_bar.visible = Global.show_health_bars and health_bar_visible

# Hide the health bar initially
func hide_health_bar():
	health_bar.visible = false
	health_bar_visible = false
