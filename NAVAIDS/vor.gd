extends Node2D
class_name VOR
@export var FREQ:String
var test_sprite = preload("res://test_texture.tscn")
func _ready() -> void:
	var sprite:Sprite2D = test_sprite.instantiate()
	sprite.position = Vector2.ZERO
	add_child(sprite)
func get_deflection(acft_pos:Vector2,to:int):
	#to is the desired course to be flown to/from the VOR
	var vec = Vector2(sin(deg_to_rad(to)),-cos(deg_to_rad(to))).normalized()
	var disp = (position-acft_pos).normalized()
	var deflection = rad_to_deg(acos(disp.dot(vec)))
	#if deflection > 90:
	#	deflection = 180-deflection
	print(to)
	return Vector2(deflection*sign(vec.cross(disp)),0)
func get_type():
	return "VOR"
