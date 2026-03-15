extends Node3D

@export var mouse_sensitivity: float = 0.002

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * mouse_sensitivity
		# Don't explicity need to wrap rotation y
		rotation.y = wrapf(rotation.y, 0.0, TAU) 
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, deg_to_rad(-90), deg_to_rad(45))
