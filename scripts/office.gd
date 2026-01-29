extends Node2D

@warning_ignore("integer_division")
var office_x = 270/2

var on_cameras = false
var prev_in_bottom = false

var cam = "1c"

var where = "office"

var left_light = false
var right_light = false
var right_door = false

func _process(_delta: float) -> void:
	if where == "office":
		$Camera.visible = false
		for button: Button in [$ButtonDoorLeft, $ButtonLightLeft, $ButtonDoorRight, $ButtonLightRight, $Nose]:
			button.disabled = false
		
		var mouse_x = get_viewport().get_mouse_position().x
		if mouse_x <= 200:
			office_x -=10
			if office_x < 0:
				office_x = 0
		elif mouse_x >= 950:
			office_x +=10
			if office_x > 270:
				office_x = 270
		
		var mouse_y = get_viewport().get_mouse_position().y
		if mouse_y >= 550:
			if not prev_in_bottom:
				$SFX.stream = load("res://assets/sounds/cameras.wav")
				$SFX.play()
				$UI/CameraAnimation.visible = true
				if not on_cameras:
					on_cameras = true
					$UI/CameraAnimation.play("open")
				else:
					on_cameras = false
					$UI/CameraAnimation.play("close")
			prev_in_bottom = true
		else:
			prev_in_bottom = false
		
		if prev_in_bottom:
			$UI/CameraArrow.visible = false
		else:
			$UI/CameraArrow.visible = true
		
		if (left_light or right_light) and not $Lights.playing:
			$Lights.play()
		else:
			$Lights.stop()
		
		if left_light:
			$Sprite2D.texture = load("res://assets/images/office/left_light.png")
			$ButtonLeft.region_rect  = Rect2(100, 4, 92, 247)
			if right_door:
				$ButtonRight.region_rect = Rect2(196, 255, 92, 247)
			else:
				$ButtonRight.region_rect = Rect2(4, 255, 92, 247)
		elif right_light:
			$ButtonLeft.region_rect  = Rect2(4, 4, 92, 247)
			$Sprite2D.texture = load("res://assets/images/office/right_light.png")
			if right_door:
				$ButtonRight.region_rect = Rect2(292, 255, 92, 247)
			else:
				$ButtonRight.region_rect = Rect2(100, 255, 92, 247)
		else:
			$Sprite2D.texture = load("res://assets/images/office/default.png")
			$ButtonLeft.region_rect  = Rect2(4, 4, 92, 247)
			if right_door:
				$ButtonRight.region_rect = Rect2(196, 255, 92, 247)
			else:
				$ButtonRight.region_rect = Rect2(4, 255, 92, 247)
		
		$Camera2D.position.x = 576.0 + office_x
	elif where == "cameras":
		for button: Button in [$ButtonDoorLeft, $ButtonLightLeft, $ButtonDoorRight, $ButtonLightRight, $Nose]:
			button.disabled = true
		$Camera.visible = true
		$Camera/View/Room.visible = true
		$Camera/View/Room.animation = cam
		
		var states = [
			$Animatronics.dogday["cam"] == cam,
			$Animatronics.furry_catnap["cam"] == cam,
			$Animatronics.catnap17["cam"] == cam,
			$Animatronics.theo["cam"] == cam,
			$Animatronics.bootleg_catnap["cam"] == cam,
			"9" == cam,
			cam == "1c" or $Animatronics.kuddle_kitty["on_cameras"],
			false, #photo
			false, #blood
		]
		var cameras = [$Camera/View/Dogday, $Camera/View/FurryCatnap, $Camera/View/Catnap17, $Camera/View/Theo, $Camera/View/BootlegCatnap, $Camera/View/Boyfriend, $Camera/View/KuddleKitty, $Camera/View/Photo, $Camera/Blood]
		
		for i in range(9):
			var state = states[i]
			var camera: AnimatedSprite2D = cameras[i]
			if cam in camera.sprite_frames.get_animation_names():
				
				camera.animation = cam
				if i == 6: #kuddle
					camera.frame = $Animatronics.kuddle_kitty["stade"]
				camera.play()
				camera.visible = state
			else:
				camera.visible = false
		
		var mouse_y = get_viewport().get_mouse_position().y
		if mouse_y >= 550:
			if not prev_in_bottom:
				$SFX.stream = load("res://assets/sounds/cameras.wav")
				$SFX.play()
				where = "office"
				$UI/CameraAnimation.visible = true
				if not on_cameras:
					on_cameras = true
					$UI/CameraAnimation.play("open")
				else:
					on_cameras = false
					$UI/CameraAnimation.play("close")
			prev_in_bottom = true
		else:
			prev_in_bottom = false
		
		if prev_in_bottom:
			$UI/CameraArrow.visible = false
		else:
			$UI/CameraArrow.visible = true
		
func _on_ambience_finished() -> void:
	$Ambience.play()

func _on_button_door_left_toggled(_toggled_on: bool) -> void:
	$SFX.stream = load("res://assets/sounds/office/error.wav")
	$SFX.play()

func _on_button_door_right_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$DoorRight.play("close")
		$SFX.stream = load("res://assets/sounds/office/door.wav")
		$SFX.play()
		right_door = true
	else:
		$DoorRight.play("open")
		$SFX.stream = load("res://assets/sounds/office/door.wav")
		$SFX.play()
		right_door = false

func _on_button_light_left_toggled(toggled_on: bool) -> void:
	left_light = toggled_on
	right_light = false

func _on_button_light_right_toggled(toggled_on: bool) -> void:
	right_light = toggled_on
	left_light = false

func _on_nose_pressed() -> void:
	var dir = DirAccess.open("res://assets/sounds/office/memes bien drôles")
	if dir == null:
		return

	var sounds = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".mp3"):
			sounds.append("res://assets/sounds/office/memes bien drôles" + "/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if sounds.is_empty():
		return

	var rng = RandomNumberGenerator.new()
	var sound_path = sounds[rng.randi_range(0, sounds.size() - 1)]

	var player = AudioStreamPlayer.new()
	player.stream = load(sound_path)
	add_child(player)

	player.finished.connect(func():
		player.queue_free()
	)

	player.play()

func _on_camera_animation_animation_finished() -> void:
	if $UI/CameraAnimation.animation == "close":
		where = "office"
	else:
		where = "cameras"
	$UI/CameraAnimation.visible = false
