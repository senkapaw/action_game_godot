extends CharacterBody2D

@export var Move_Speed: float = 260.0
@export var Left_Key: Key = KEY_A
@export var Right_Key: Key = KEY_D
@export var Up_Key: Key = KEY_W
@export var Down_Key: Key = KEY_S

func _physics_process(_delta: float) -> void:
	var input_direction := Vector2.ZERO

	if Input.is_key_pressed(Left_Key):
		input_direction.x -= 1.0
	if Input.is_key_pressed(Right_Key):
		input_direction.x += 1.0
	if Input.is_key_pressed(Up_Key):
		input_direction.y -= 1.0
	if Input.is_key_pressed(Down_Key):
		input_direction.y += 1.0

	velocity = input_direction.normalized() * Move_Speed
	move_and_slide()

	var view_size := get_viewport_rect().size
	global_position.x = clamp(global_position.x, 20.0, view_size.x - 20.0)
	global_position.y = clamp(global_position.y, 20.0, view_size.y - 20.0)
