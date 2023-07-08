extends CharacterBody2D

# Enemy movement speed
@export var speed = 50

#it’s the current movement direction of the cactus enemy.
var direction : Vector2

#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces

# RandomNumberGenerator to generate timer countdown value 
var rng = RandomNumberGenerator.new()

#timer reference to redirect the enemy if collision events occur & timer countdown reaches 0
var timer = 0

#player scene ref
var player

var animation

#attack anim state
var is_attacking = false

#When the enemy enters the scene tree, we need to do two things:
#Initialize the Player node reference
#Initialize the random number generator
func _ready():
	player = get_tree().root.get_node("World/player")
	rng.randomize()
	
# Apply movement to the enemy
func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)
	
	#if the enemy collides with other objects, turn them around and re-randomize the timer countdown
	if collision != null and collision.get_collider().name != "Player":
		#direction rotation
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		#timer countdown random range
		timer = rng.randf_range(2, 5)
	#if they collide with the player
	#trigger the timer's timeout() so that they can chase/move towards our player 
	else:
		timer = 0
	#plays animations only if the enemy is not attacking
	if !is_attacking:
		enemy_animations(direction)
	
#syncs new_direction with the actual movement direction and is called whenever the enemy moves or rotates
func sync_new_direction():
	if direction != Vector2.ZERO:
		new_direction = direction.normalized()
	
func _on_timer_timeout():
	var player_distance = player.position - position
	#attack radius
	if player_distance.length() <= 20:
		new_direction = player_distance.normalized()
		sync_new_direction()
		direction = Vector2.ZERO # Stop moving while attacking
	
	#chase radius
	#chase/move towards player to attack them
	elif player_distance.length() <= 100 and timer == 0:
		direction = player_distance.normalized()
		sync_new_direction()
	
	#random roam radius
	elif timer == 0:
		#this will generate a random direction value
		var random_direction = rng.randf()
		#This direction is obtained by rotating Vector2.DOWN by a random angle.
		if random_direction < 0.05:
			#enemy stops
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			#enemy moves
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		sync_new_direction()
			
			
			
func returned_direction(direction : Vector2):
	#it normalizes the direction vector to make sure it has length 1 (1, or -1 up, down, left, and right) 
	var normalized_direction  = direction.normalized()

	if normalized_direction.y >= 1:
		return "down"
	elif normalized_direction.y <= -1:
		return "up"
	elif normalized_direction.x >= 1:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x <= -1:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"
		
	#default value is empty
	return ""
			
			
			
func enemy_animations(direction : Vector2):
	#Vector2.ZERO is the shorthand for writing Vector2(0, 0).
	if direction != Vector2.ZERO:
	#update our direction with the new_direction
		new_direction = direction
		#play walk animation because we are moving
		animation = "walk " + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)
	else:
	#play idle animation because we are still
		animation  = "idle " + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation) 
		


	
		






