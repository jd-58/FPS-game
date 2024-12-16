class_name PlayerMovementState

extends State

var PLAYER: Player
var ANIMATION: AnimationPlayer


func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATIONPLAYER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass