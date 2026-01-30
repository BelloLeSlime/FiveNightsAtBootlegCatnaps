extends Node2D

@onready var office = $"../.."
@onready var sfx = $"../../SFX"

func _on_1a_pressed() -> void:
	office.cam = "1a"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_1b_pressed() -> void:
	office.cam = "1b"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_1c_pressed() -> void:
	office.cam = "1c"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_a_pressed() -> void:
	office.cam = "2a"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_b_pressed() -> void:
	office.cam = "2b"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on__pressed() -> void:
	office.cam = "3"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_4a_pressed() -> void:
	office.cam = "4a"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_4b_pressed() -> void:
	office.cam = "4b"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_5_pressed() -> void:
	office.cam = "5"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()

func _on_6_pressed() -> void:
	office.cam = "6"
	sfx.stream = load("res://assets/sounds/office/camera.wav")
	sfx.play()
