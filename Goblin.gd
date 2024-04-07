extends Area2D

@export var speed = 175
var game_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_active:
		move_to_closest_coin(delta)

func get_closest_coin_or_null():
	var all_coins = get_tree().get_nodes_in_group("Coins")
	var closest_coin = null
	
	if (all_coins.size() > 0):
		closest_coin = all_coins[0]
		for coin in all_coins:
			var distance_to_this_coin = global_position.distance_squared_to(coin.global_position)
			var distance_to_closest_coin = global_position.distance_squared_to(closest_coin.global_position)
			if (distance_to_this_coin < distance_to_closest_coin):
				closest_coin = coin
	
	return closest_coin
	
func move_to_closest_coin(delta):
	var closest_coin = get_closest_coin_or_null()
	if (closest_coin == null):
		return
	
	if (closest_coin != null):
		var direction = position.direction_to(closest_coin.position)
		
		var velocity = direction * speed
		position += velocity * delta

func _on_main_game_end(winner):
	set_process(false)
	if (winner == "Goblin"):
		$AnimationPlayer.play("dance")
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = false
	else:
		$AnimationPlayer.play("lose")
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = false

func _on_main_game_active():
	game_active = true
