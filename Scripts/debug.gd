extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer


var frames_per_second : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Set global reference to self in Global Singleton
	Global.debug = self
	
	#Hide debug panel on load
	visible = false
	
	


func _input(event):
	# Toggle debug panel
	if event.is_action_pressed('Debug'):
		visible = !visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if visible:
		# Use delta time to get approx FPS and round to 2 decimal places !Disable
		# VSync if FPS is stuck at monitor refresh rate!
		frames_per_second = "%.2f" % (1.0/delta) # get FPS every frame



func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false) # Try to find label node with same name
	if !target: # If there is no current label node for property (i.e. initial load)
		target = Label.new() # Create new label node
		property_container.add_child(target) # Add new node as child to VBox container
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value) # Update text value
		property_container.move_child(target,order) # Reorder property based on given order value
	
