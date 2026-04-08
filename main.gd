extends Node2D

var Fall_Speed: float = 140.0
var Reset_Y: float = 680.0
var Start_Y: float = -80.0
var Obstacle_Nodes: Array[StaticBody2D] = []

func _ready() -> void:
	for child in $Obstacles.get_children():
		if child is StaticBody2D:
			Obstacle_Nodes.append(child)


func _process(delta: float) -> void:
	for obstacle in Obstacle_Nodes:
		obstacle.position.y += Fall_Speed * delta
		if obstacle.position.y > Reset_Y:
			obstacle.position.y = Start_Y
