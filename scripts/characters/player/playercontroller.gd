extends CharacterBody2D

@export var speed: float = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	
	var direction = mouse_position.x - global_position.x

	if direction > 0:
		animated_sprite.flip_h = true  # Face right
	elif direction < 0:
		animated_sprite.flip_h = false  # Face left

	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += 1
	elif Input.is_action_pressed("left"):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	move_and_slide()

	if velocity.x != 0:
		animated_sprite.play("walk_L")
	else:
		if animated_sprite.animation != "idle_L":
			animated_sprite.play("idle_L")
