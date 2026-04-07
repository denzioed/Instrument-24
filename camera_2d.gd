extends Camera2D
var pressed = false
var debug = false
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pressed = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print(get_viewport_rect().size)
			var gp = offset+(event.global_position-(get_viewport_rect().size/2))/zoom
			print(gp)
			zoom /= 1.1
			var gp2 = offset+(event.global_position-(get_viewport_rect().size/2))/zoom
			if debug:
				offset += gp-gp2
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var gp = offset+(event.global_position-(get_viewport_rect().size/2))/zoom
			zoom *= 1.1
			var gp2 = offset+(event.global_position-(get_viewport_rect().size/2))/zoom
			if debug:
				offset += gp-gp2
	elif event is InputEventMouseMotion and pressed:
		if debug:
			offset -= event.screen_relative/zoom
