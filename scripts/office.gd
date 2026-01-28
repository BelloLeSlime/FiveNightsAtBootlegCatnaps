extends Node2D

@warning_ignore("integer_division")
var office_x = 270/2

var left_light = false
var right_light = false
var right_door = true

func _process(_delta: float) -> void:
	var mouse_x = get_viewport().get_mouse_position().x
	if mouse_x <= 200:
		office_x -=10
		if office_x < 0:
			office_x = 0
	elif mouse_x >= 950:
		office_x +=10
		if office_x > 270:
			office_x = 270
	
	if (left_light or right_light) and not $Lights.playing:
		$Lights.play()
	else:
		$Lights.stop()
	
	$Camera2D.position.x = 576.0 + office_x

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

func _on_button_light_right_toggled(toggled_on: bool) -> void:
	right_light = toggled_on

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
