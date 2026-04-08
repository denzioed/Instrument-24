extends Control
@onready var original_pos_VERT = $CDI/VERT.position
@onready var original_pos_HORI = $CDI/HORI.position
@export var gs_dot_deflection = 0.35
@export var loc_dot_deflection = 0.5
signal obs_change
var obs_hovering = false
var OBS_OUT = 0
var scales = {
	"LOC":[0.35,0.5],
	"VOR":[null,2]
}
func deflect(deg,fix_type):
	if fix_type != "VOR":
		$Label.text = ""
	var hori = scales[fix_type][0]
	var vert = scales[fix_type][1]
	var deflectx = Vector2.ZERO
	var deflecty = Vector2.ZERO
	if abs(deg.x) > 90:
		deg.x = (180-abs(deg.x))*sign(deg.x)
		$Label.text = "FROM"
	else:
		$Label.text = "TO"
	if vert:
		deflectx = Vector2(clamp(deg.x*(50/vert),-200,200),0)
	if hori:
		deflecty = Vector2(0,clamp(deg.y*(50/hori),-200,200))
	$CDI/VERT.position = original_pos_VERT + deflectx
	$CDI/HORI.position = original_pos_HORI + deflecty
func _process(delta: float) -> void:
	if not obs_hovering:
		return
	var flag = false
	if Input.is_action_just_released("dial_down"):
		OBS_OUT -= 1
		flag = true
	elif Input.is_action_just_released("dial_up"):
		OBS_OUT += 1
		flag = true
	if flag:
		OBS_OUT %= 360
		$RING.rotation = -deg_to_rad(OBS_OUT)
		obs_change.emit(OBS_OUT)
func _on_obs_mouse_entered() -> void:
	obs_hovering = true


func _on_obs_mouse_exited() -> void:
	obs_hovering = false
