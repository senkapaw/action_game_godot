extends Node2D

var Block_Texture = preload("res://Resources/Block.png")

var Levels := [
	[
		{"x": 320, "y_off": 30, "w": 140},
		{"x": 530, "y_off": 60, "w": 110},
		{"x": 740, "y_off": 30, "w": 140},
		{"x": 920, "y_off": 60, "w": 110},
	],
	[
		{"x": 270, "y_off": 30, "w": 110},
		{"x": 430, "y_off": 65, "w": 90},
		{"x": 580, "y_off": 35, "w": 110},
		{"x": 730, "y_off": 80, "w": 90},
		{"x": 880, "y_off": 40, "w": 110},
	],
	[
		{"x": 240, "y_off": 35, "w": 70},
		{"x": 370, "y_off": 70, "w": 70},
		{"x": 500, "y_off": 35, "w": 90},
		{"x": 630, "y_off": 90, "w": 70},
		{"x": 760, "y_off": 50, "w": 70},
		{"x": 890, "y_off": 85, "w": 70},
	],
]

var P1_Level := 0
var P2_Level := 0
var P1_Checkpoint := false
var P2_Checkpoint := false

func _ready() -> void:
	$Top_Lava.body_entered.connect(_on_lava_hit)
	$Bottom_Lava.body_entered.connect(_on_lava_hit)
	build_zone($Top_Platforms, P1_Level, 290.0)
	build_zone($Bottom_Platforms, P2_Level, 614.0)

func _process(_delta: float) -> void:
	if not P1_Checkpoint and $Player_1.global_position.x > 960:
		P1_Checkpoint = true
		$Player_1.set_checkpoint(Vector2(970, 265))

	if not P2_Checkpoint and $Player_2.global_position.x > 960:
		P2_Checkpoint = true
		$Player_2.set_checkpoint(Vector2(970, 589))

	if $Player_1.global_position.x > 1100:
		P1_Level = (P1_Level + 1) % Levels.size()
		P1_Checkpoint = false
		build_zone($Top_Platforms, P1_Level, 290.0)
		$Player_1.Start_Position = Vector2(80, 265)
		$Player_1.global_position = Vector2(80, 265)
		$Player_1.velocity = Vector2.ZERO
		$UI/P1_Label.text = "P1: Level " + str(P1_Level + 1)

	if $Player_2.global_position.x > 1100:
		P2_Level = (P2_Level + 1) % Levels.size()
		P2_Checkpoint = false
		build_zone($Bottom_Platforms, P2_Level, 614.0)
		$Player_2.Start_Position = Vector2(80, 589)
		$Player_2.global_position = Vector2(80, 589)
		$Player_2.velocity = Vector2.ZERO
		$UI/P2_Label.text = "P2: Level " + str(P2_Level + 1)

func build_zone(container: Node2D, level_index: int, floor_y: float) -> void:
	for child in container.get_children():
		child.queue_free()

	var level_data = Levels[level_index]
	for plat in level_data:
		var body := StaticBody2D.new()
		body.position = Vector2(plat["x"], floor_y - plat["y_off"])

		var col := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = Vector2(plat["w"], 20)
		col.shape = rect
		body.add_child(col)

		var spr := Sprite2D.new()
		spr.texture = Block_Texture
		spr.scale = Vector2(float(plat["w"]) / 32.0, 0.625)
		body.add_child(spr)

		container.add_child(body)

func _on_lava_hit(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
