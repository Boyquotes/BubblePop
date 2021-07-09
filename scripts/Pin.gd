extends Area2D


func _ready():
	#Enable event processing
	set_process_input(true)
	
	
func _input(event):
	#Process input
	if (event.type == InputEvent.MOUSE_MOTION or 
	    event.type == InputEvent.SCREEN_DRAG):
		set_pos(event.pos)
