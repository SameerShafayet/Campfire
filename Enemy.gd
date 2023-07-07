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


#When the enemy enters the scene tree, we need to do two things:
#Initialize the Player node reference
#Initialize the random number generator
func _ready():
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()


