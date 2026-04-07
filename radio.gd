extends Control
var first_part = 123
var second_part = 45
var big_hover = false
var small_hover = false
func _ready() -> void:
	$TextureRect/CURRENT.text = ("%03d" % first_part) + "." + ("%02d" % second_part)
func _process(delta: float) -> void:
	if not (big_hover or small_hover):
		return
	var flag = false
	var change = 0
	if Input.is_action_just_released("dial_down"):
		change = -1
		flag = true
	elif Input.is_action_just_released("dial_up"):
		change = 1
		flag = true
	if flag:
		if big_hover:
			first_part += change
		else:
			second_part += change
		if first_part>=200:
			first_part = 100
		elif first_part<100:
			first_part = 199
		if second_part>=100:
			second_part = 0
		elif second_part<0:
			second_part = 99
		$TextureRect/CURRENT.text = ("%03d" % first_part) + "." + ("%02d" % second_part)
func get_freq():
	return str(first_part)+"."+str(second_part)+"0"
func _on_dial_big_mouse_entered() -> void:
	big_hover = true
func _on_dial_big_mouse_exited() -> void:
	big_hover = false
func _on_dial_small_mouse_entered() -> void:
	small_hover = true
func _on_dial_small_mouse_exited() -> void:
	small_hover = false
