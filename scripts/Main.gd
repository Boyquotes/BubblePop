extends Node

export (PackedScene) var Bubble
var screen_size
export var max_bubbles = 10
var bubble_cnt = 0
var score = 0


func _ready():
	#Initialize random number generator, store current
	#screen size, and spawn first bubble
	randomize()
	screen_size = get_viewport().get_rect().size
	spawn_bubble()
	
	#Start bubble spawn timer
	get_node("BubbleSpawnTimer").start()
	
	
func spawn_bubble():
	#Are there already enough bubbles?
	if bubble_cnt > max_bubbles:
		return
	
	#Create new bubble and add it to the main scene
	var bubble = Bubble.instance()
	add_child(bubble)
	bubble.connect("score", self, "update_score", [100])
	bubble.connect("popping", self, "bubble_popping")
	bubble.connect("popped", self, "bubble_popped")
	
	#Randomize start position
	var bubble_size = bubble.get_node("AnimatedSprite").get_item_rect().size * bubble.get_scale()
	var pos = Vector2(
	    rand_range(bubble_size.x / 2, screen_size.x - bubble_size.x / 2),
	    rand_range(bubble_size.y / 2, screen_size.y - bubble_size.y / 2)
	)
	bubble.set_pos(pos)
	
	#Update bubble count
	bubble_cnt += 1
	
	
func update_score(inc):
	#Increment (or decrement) the score and update the score
	#counter
	score += inc
	get_node("HUD/ScoreCounter").set_text(str(score))
	
	
func bubble_popping():
	#Play bubble pop sound effect
	get_node("SamplePlayer").play("bubble-pop")
	
	
func bubble_popped():
	#Decrement bubble count
	bubble_cnt -= 1
