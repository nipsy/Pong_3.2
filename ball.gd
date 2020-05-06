extends KinematicBody2D

# set up some initial conditions for the ball
export var _initial_thrust = 100
export var _initial_angle = 30
export var max_thrust = 500

var thrust : int

onready var _initial_pos = position
onready var velocity = get_start_vector()

# set initial vector for ball; called at start and if either player scores 11 points
func get_start_vector():
	thrust = _initial_thrust
	
	# choose randomly between two different starting angles aimed generally at each paddle
	var angle = rand_range(180 - _initial_angle / 2, 180 + _initial_angle /2) \
		if (randi() % 2) else rand_range(0 - _initial_angle / 2, 0 + _initial_angle)
		
	angle = deg2rad(angle)
	return Vector2(thrust * cos(angle), thrust * sin(angle))

# seed the RNG
func _ready():
	randomize()

# all of the ball physics are handled here
func _physics_process(delta):
	
	# try moving the ball over the length of its current velocity vector
	var collision = move_and_collide(velocity * delta)
	
	# the ball hit something
	if collision:
		
		# handle paddle collisions
		if collision.collider.get_parent().name == "paddles":
			
			# initial bounce angle offset set shortly
			var return_angle : float
			
			# find vertical (y) offset between ball and paddle
			var offset = position.y - collision.collider.position.y
			
			# only care about the distance from center
			var abs_offset = abs(offset)
			
			# set bounce angle offset maximum based on distance from center of paddle
			if abs_offset >= 12:
				return_angle = 35
			elif abs_offset < 12 && abs_offset >= 10:
				return_angle = 30
			elif abs_offset < 10 && abs_offset >= 8:
				return_angle = 25
			elif abs_offset < 8 && abs_offset >= 6:
				return_angle = 20
			elif abs_offset < 6 && abs_offset >= 4:
				return_angle = 15
			elif abs_offset < 4 && abs_offset >= 2:
				return_angle = 10
			elif abs_offset < 2:
				return_angle = 5
				
			# set return angle as random float +-5 degrees from our initial offset
			return_angle = rand_range(-return_angle, return_angle)
			
			# calculate the actual bounce vector for this collision and
			# adjust angle by the random return agnle offset; also increases
			# thrust slightly to make sure the game ends eventually
			velocity = velocity.bounce(collision.normal).rotated(deg2rad(return_angle)) * 1.2
			
		else:
				# bouncing off anything else is calculated as a straight bounce vector
				velocity = velocity.bounce(collision.normal)

		# additionally, check for out of bounds condition simulated by left and right wall			
		if collision.collider.get_parent().name == "walls":
			if collision.collider.name == "left" || collision.collider.name == "right":
				
				# ternary to increase appropriate player's score
				var opponent = "right" if (collision.collider.name == "left") else "left"
				
				# traversing nodes absolutely is possibly frowned upon due to making
				# this code somehat fragile; but allowing for now as an example
				
				# call player's update_score method
				var score = get_node("/root/game/paddles/" + opponent).update_score()
				
				# detect winning game condition and reset game
				if score == 11:
					get_tree().reload_current_scene()
					
				# if game hasn't ended, reset ball to starting location and calculate
				# new random release vector
				position = _initial_pos
				velocity = get_start_vector()
				
		# lastly, ensure velocity remains below maximum defined thrust value
		velocity = velocity.clamped(max_thrust)
