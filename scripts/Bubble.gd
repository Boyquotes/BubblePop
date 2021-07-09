extends Area2D
signal score
signal popping
signal popped

var screen_size
export var speed = 64
var velocity = Vector2(1, 0)
var hp = 10


func _ready():
	#Store the current screen size, set the initial position,
	#and enable event processing
	screen_size = get_viewport_rect().size
	
	var size = get_node("AnimatedSprite").get_item_rect().size * get_scale()
	var pos = Vector2(size.x / 2, size.y / 2)
	set_pos(pos)
	
	set_process(true)
	
	#Randomize initial velocity
	velocity = velocity.rotated(rand_range(0, 360)) * speed
	
	
func _process(delta):
	#Update the bubble position
	var pos = get_pos()
	var size = get_node("AnimatedSprite").get_item_rect().size * get_scale()
	pos += velocity * delta
	
	if (pos.x < size.x / 2 or 
	    pos.x > screen_size.x - size.x / 2):
		velocity.x = -velocity.x
		
	if (pos.y < size.y / 2 or 
	    pos.y > screen_size.y - size.y / 2):
		velocity.y = -velocity.y
		
	set_pos(pos)


func _on_Bubble_area_enter(area):
	#Did the bubble hit the pin?
	if area.get_name() == "Pin":
		#Pop the bubble instantly and emit score signal
		pop()
		emit_signal("score")
		
	else:
	    #Subtract 1 hp from the bubble and reverse its velocity
	    update_hp(-1)
	    velocity = -velocity
	
	
func _on_PopTimer_timeout():
	#Emit popped signal, and mark this bubble to be freed
	emit_signal("popped")
	queue_free()
	
	
func update_hp(inc):
	#Increment (or decrement) the current hp of the bubble
	#and pop it if it has 0 or less hp
	hp += inc
	
	if hp <= 0:
		pop()
		
		
func pop():
	#Set the velocity to 0, play pop animation, 
	#disable collision, start the pop timer, and emit popping
	#signal
	velocity = Vector2()
	get_node("AnimatedSprite").play("pop")
	set_layer_mask(0)
	set_collision_mask(0)
	get_node("PopTimer").start()
	emit_signal("popping")
