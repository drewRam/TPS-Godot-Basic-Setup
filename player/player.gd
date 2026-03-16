extends CharacterBody3D

const speed = 5.0
const jump_velocity = 4.5
var is_jumping = false

@onready var camera = $CameraRig
@onready var character_mesh = $GobotSkin

# Use your own animations, this is free godot model stuff
@onready var x = $GobotSkin/AnimationTree

func _unhandled_input(_event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
		
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	## Camera relative direction
	var forward = camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction := Input.get_vector("left", "right", "forward", "back")
	var move_direction = (forward * input_direction.y + right * input_direction.x).normalized()
	
	if move_direction:
		velocity.x = move_direction.x * speed
		velocity.z = move_direction.z * speed
		
		# Rotate the character to face the movement direction.
		if move_direction.length() > 0.01:
			var target_angle := atan2(move_direction.x, move_direction.z)
			character_mesh.rotation.y = lerp_angle(
				character_mesh.rotation.y,
				target_angle,
				delta * 10
			)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Animation control for gdquest_gobot. 
	if not is_on_floor():
		if velocity.y > 0.01:
			character_mesh.jump()
		else:
			character_mesh.fall()
	elif move_direction:
		character_mesh.run()
	else:
		character_mesh.idle()
		
	move_and_slide()
