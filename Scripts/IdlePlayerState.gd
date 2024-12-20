class_name IdlePlayerState

extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25

func enter(previous_state) -> void:
	ANIMATION.pause()


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed('Crouch') and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_just_pressed('Jump') and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
