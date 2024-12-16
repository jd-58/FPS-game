class_name SprintingPlayerState extends PlayerMovementState

@export var TOP_ANIM_SPEED : float = 1.6
@export var SPEED : float = 7.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25

func enter() -> void:
	ANIMATION.play("Sprinting",0.5,1.0)


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(Global.player.velocity.length())
	
	if Input.is_action_just_released("Sprint"):
		transition.emit("WalkingPlayerState")


func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
	
