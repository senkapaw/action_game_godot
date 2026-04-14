extends CharacterBody2D

var Running_Tex = preload("res://Resources/P2_Running.png")
var Jumping_Tex = preload("res://Resources/P2_Jumping.png")
var Speed := 200.0
var Jump_Force := -400.0
var Gravity := 900.0
var Is_Dead := false
var Start_Position := Vector2(80, 594)

func _physics_process(delta: float) -> void:
	if Is_Dead:
		return

	velocity.y += Gravity * delta

	var direction := 0.0
	if Input.is_key_pressed(KEY_LEFT):
		direction = -1.0
	if Input.is_key_pressed(KEY_RIGHT):
		direction = 1.0

	velocity.x = direction * Speed

	if is_on_floor() and Input.is_key_pressed(KEY_UP):
		velocity.y = Jump_Force

	move_and_slide()

	if is_on_floor():
		$Sprite.texture = Running_Tex
	else:
		$Sprite.texture = Jumping_Tex

	if direction != 0.0:
		$Sprite.flip_h = direction < 0.0

	var screen := get_viewport_rect().size
	global_position.x = clamp(global_position.x, 10.0, screen.x - 10.0)

func die() -> void:
	Is_Dead = true
	visible = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	global_position = Start_Position
	visible = true
	Is_Dead = false

func set_checkpoint(pos: Vector2) -> void:
	Start_Position = pos
