class_name WalkingPlayerState

extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCELERATION : float = 0.05
@export var DECELERATION : float = 0.05
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
	ANIMATION.play("Walking",-1.0,1.0)
	
func exit() -> void:
	ANIMATION.speed_scale = 1.0


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("Sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
		
	if Input.is_action_just_pressed('Crouch') and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
	
