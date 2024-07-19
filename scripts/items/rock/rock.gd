extends Sprite2D

@export var outline_color: Color = Color(0.929, 0.929, 0.875, 1)  # #ededdf

var unique_material: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create a unique material for this instance
	if material:
		unique_material = material.duplicate() as ShaderMaterial
		unique_material.shader = material.shader  # Ensure the shader is also copied
		material = unique_material

	$Area2D.connect("mouse_entered", Callable(self, "_on_Area2D_mouse_entered"))
	$Area2D.connect("mouse_exited", Callable(self, "_on_Area2D_mouse_exited"))
	$Area2D.connect("input_event", Callable(self, "_on_Area2D_input_event"))
	hide_outline()  # Initially hide the outline

func _on_Area2D_mouse_entered():
	show_outline()

func _on_Area2D_mouse_exited():
	hide_outline()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$AnimationPlayer.play("shake")

func show_outline():
	# Set the shader parameters
	if unique_material:
		unique_material.set_shader_parameter("outline_enabled", true)
		unique_material.set_shader_parameter("outline_color", outline_color)

func hide_outline():
	# Set the shader parameter
	if unique_material:
		unique_material.set_shader_parameter("outline_enabled", false)
