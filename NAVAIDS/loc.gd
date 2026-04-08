extends Node2D
class_name LOC
@export var CRS:int
@export var FREQ:String
@onready var vec = Vector2(sin(deg_to_rad(CRS)),-cos(deg_to_rad(CRS))).normalized()

func get_deflection(acft_pos:Vector2,altitude):
	var disp = (position-acft_pos).normalized()
	var proj = abs((position-acft_pos).dot(vec))*183.72
	var GlideSlope = get_node("GS")
	var vertical_deflection = 0
	if GlideSlope:
		vertical_deflection = GlideSlope.get_deflection(acft_pos,altitude)
	return Vector2(rad_to_deg(acos(disp.dot(vec))*sign(vec.cross(disp))),vertical_deflection)
func get_type():
	return "LOC"
