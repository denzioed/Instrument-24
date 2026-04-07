extends Node2D
class_name LOC
@export var CRS:int
@export var GS = 3
@export var ELEV = 0
@export var FREQ:String
@onready var vec = Vector2(sin(deg_to_rad(CRS)),-cos(deg_to_rad(CRS))).normalized()

func get_deflection(acft_pos:Vector2,altitude):
	var disp = (position-acft_pos).normalized()
	var proj = abs((position-acft_pos).dot(vec))*183.72
	altitude -= ELEV
	var vertical_deflection = rad_to_deg(atan(altitude/proj))-GS
	return Vector2(rad_to_deg(acos(disp.dot(vec))*sign(vec.cross(disp))),vertical_deflection)
func get_type():
	return "VOR"
