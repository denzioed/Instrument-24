extends Node2D
class_name GS
@export var angle = 3
@onready var CRS = get_parent().CRS
@export var ELEV = 0
@onready var vec = Vector2(sin(deg_to_rad(CRS)),-cos(deg_to_rad(CRS))).normalized()
func get_deflection(acft_pos:Vector2,altitude):
	var proj = abs((global_position-acft_pos).dot(vec))*183.72
	altitude -= ELEV
	return rad_to_deg(atan(altitude/proj))-angle
