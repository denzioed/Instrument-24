extends Node2D

@export var websocket_url = "wss://24data.ptfs.app/wss"
@export var plane_sprite:PackedScene
@export var target_callsign:String
var socket = WebSocketPeer.new()
var plane_sprites = {}
var deflection:Vector2
var InstWindow = preload("res://InstrumentWindow.tscn")
var CDI = preload("res://CDI.tscn")
var radio = preload("res://RADIO.tscn")
var win
var radio_win:Window
var navaid_dictionary = {}
@onready var cam = $Camera2D
var done = false
func _ready():
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err == OK:
		print("Connecting to %s..." % websocket_url)
	win = InstWindow.instantiate()
	win.title = "Nav1"
	var cdi_used = CDI.instantiate()
	win.add_child(cdi_used)
	$WindowsNode.add_child(win)
	win.init_win()
	radio_win = InstWindow.instantiate()
	radio_win.title = "Nav1"
	var r = radio.instantiate()
	radio_win.add_child(r)
	$WindowsNode.add_child(radio_win)
	radio_win.init_win()
	for fix in $NAVAIDS.get_children():
		if fix.FREQ and len(fix.FREQ)>0:
			navaid_dictionary[fix.FREQ] = fix
	cdi_used.connect("obs_change",_on_cdi_obs_change)
var OBS_OUT = 0
var assigned_callsign = ""
func _process(_delta):
	for keys in plane_sprites:
		plane_sprites[keys].scale = Vector2(0.8/cam.zoom.x,0.8/cam.zoom.y)
	# Call this in `_process()` or `_physics_process()`.
	# Data transfer and state updates will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()
	
	# `WebSocketPeer.STATE_OPEN` means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				var data = JSON.parse_string(packet_text)
				if data['t'] == "ACFT_DATA":
					var target_plane = data['d'].get(target_callsign)
					print(target_plane)
					if target_plane:
						var pos = Vector2(target_plane["position"]["x"],target_plane["position"]["y"])
						var fix = navaid_dictionary.get(radio_win.get_child(0).get_freq())
						if fix:
							if fix.get_type() == "LOC":
								deflection = fix.get_deflection(pos/100,target_plane["altitude"])
								print(deflection)
							elif fix.get_type() == "VOR":
								deflection = fix.get_deflection(pos/100,OBS_OUT)
							win.get_child(0).deflect(deflection,fix.get_type())
						#cam.deflect(deflection)
					for callsign in data['d']:
						var pos = data['d'][callsign]['position']
						var hdg = data['d'][callsign]['heading']
						var sprite:Node2D = plane_sprites.get(callsign)
						if not sprite:
							sprite = plane_sprite.instantiate()
							plane_sprites[callsign] = sprite
							self.add_child(sprite)
						if target_callsign == callsign and not done:
							print("Add: ",callsign)
							remove_child(cam)
							sprite.add_child(cam)
							done = true
							assigned_callsign = callsign
						if target_callsign != assigned_callsign and done and assigned_callsign==callsign:
							print("Remove: ",assigned_callsign)
							assigned_callsign = ""
							sprite.remove_child(cam)
							add_child(cam)
							done = false
						sprite.position = Vector2(pos['x'],pos['y'])/100
						sprite.rotation_degrees = hdg
				


func _on_cdi_obs_change(obs) -> void:
	OBS_OUT = obs

func _on_text_edit_text_changed() -> void:
	target_callsign = $CanvasLayer/TextEdit.text
