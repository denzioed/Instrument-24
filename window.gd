extends Window
var drag_offset: Vector2 = Vector2.ZERO
var is_dragging: bool = false
func init_win():
	size = get_child(0).size * get_child(0).scale
	print(get_child(0))
func _on_close_requested() -> void:
	hide()
	queue_free()
