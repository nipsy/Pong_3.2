extends KinematicBody2D

# define some intial paddle characteristics
export (int) var speed = 100
export (float, 0, 1.0) var acceleration = 1
export (float, 0, 1.0) var friction = 0.5

var velocity = Vector2.ZERO
var player : String
var score = -1

# create method so ball can also call it
func update_score():
	score+=1
	get_node("/root/game/scores/" + name).text = str(score)
	return score

func _ready():
	# when new paddle is instantiated, determine correct input mappings
	if name == "left":
		player = "p1_"
	elif name == "right":
		player = "p2_"
		
	# this is why score starts at -1, but it also gets the zeroes drawn the first time
	update_score()
	
# how input affects the paddle
func get_input():
	
	# this possibly makes more sense if wanting to detect diagonals, but it
	# will also mean if both directions are pressed for one player that the
	# net vector is zero
	var dir = Vector2.ZERO
	
	# detects proper input mapping based on which paddle instantiated this script
	if Input.is_action_pressed(player + "up"):
		dir += Vector2.UP
	if Input.is_action_pressed(player + "down"):
		dir += Vector2.DOWN
	#if Input.is_action_pressed(player + "left"):
	#	dir += Vector2.LEFT
	#if Input.is_action_pressed(player + "right"):
	#	dir += Vector2.RIGHT
	
	# smoothly slide the paddle up and down	
	if dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)

# the extent of all of our paddle physics
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
