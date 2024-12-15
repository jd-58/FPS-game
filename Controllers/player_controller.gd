extends CharacterBody3D


var mouse_input : bool = false
var mouse_rotation : Vector3
var rotation_input : float
var tilt_input : float
var player_rotation : Vector3
var camera_rotation : Vector3
var speed : float
var is_crouching : bool = false

@export var SPEED_DEFAULT : float = 5.0
@export var SPEED_CROUCH : float = 2.0
@export var JUMP_VELOCITY : float = 4.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-70)
@export var TILT_UPPER_LIMIT := deg_to_rad(90)
@export var CAMERA_CONTROLLER : Node3D
@export var MOUSE_SENSITIVITY : float = 0.1
@export var ANIMATIONPLAYER : AnimationPlayer
@export_range(5, 10, 0.1) var CROUCH_SPEED : float = 7.0
@export var CROUCH_SHAPECAST : Node3D
@export var TOGGLE_CROUCH : bool = true



func _input(event):
	if event.is_action_pressed("Exit"):
		get_tree().quit()
	if event.is_action_pressed("Crouch"):
		toggle_crouch()
	if event.is_action_pressed("Crouch") and is_crouching == false and is_on_floor() and TOGGLE_CROUCH == false:
		# Hold to crouch
		crouching(true)
	if event.is_action_released('Crouch') and TOGGLE_CROUCH == false: 
		# Release to uncrouch
		if CROUCH_SHAPECAST.is_colliding() == false:
			crouching(false)
		elif CROUCH_SHAPECAST.is_colliding() == true:
			uncrouch_check()
		
		
func _update_camera(delta):
	
	# Rotate camera using Euler rotation
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	mouse_rotation.y += rotation_input * delta
	
	player_rotation = Vector3(0.0,mouse_rotation.y,0.0)
	camera_rotation = Vector3(mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = basis.from_euler(camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0.0
	
	
		
func _ready():
	
	# Set default speed
	speed = SPEED_DEFAULT
	
	# Get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# add crouch check shapecast collision exception for CharacterBody3D node
	CROUCH_SHAPECAST.add_exception($".")
	
func _unhandled_input(event):
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	_update_camera(delta)
 
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	

func toggle_crouch():
	if is_crouching == true and CROUCH_SHAPECAST.is_colliding() == false:
		crouching(false)
	elif is_crouching == false:
		crouching(true)
		
func crouching(state : bool):
	match state:
		true:
			ANIMATIONPLAYER.play('Crouch', 0, CROUCH_SPEED)
			set_movement_speed('crouching')
		false:
			ANIMATIONPLAYER.play('Crouch', 0, -CROUCH_SPEED, true)
			set_movement_speed('default')
			

func uncrouch_check():
	if CROUCH_SHAPECAST.is_colliding() == false:
		crouching(false)
	if CROUCH_SHAPECAST.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch_check()
	

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		is_crouching = !is_crouching


func set_movement_speed(state: String):
	match state:
		"default":
			speed = SPEED_DEFAULT
		"crouching":
			speed = SPEED_CROUCH
