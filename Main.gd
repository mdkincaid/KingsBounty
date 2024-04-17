extends Node2D

signal game_end(winner)
signal game_active

@export var coin_scene: PackedScene
@export var boost_scene: PackedScene
@export var coins_to_win: int
var starting_coins = 0
var player_score = 0
var goblin_score = 0
var number_of_coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_coins = get_number_of_coins_to_start()
	spawn_coins_and_hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset_game"):
		reset_game()
	if player_score >= coins_to_win:
		game_over("Player")
	if goblin_score >= coins_to_win:
		game_over("Goblin")
	if $BoostTimer.is_stopped():
		$Player.speed = 200

func _on_coin_collected(collector):
	if (collector == "Player"):
		number_of_coins -= 1
		player_score += 1
		$HUD.update_score(player_score)
	elif (collector == "Goblin"):
		number_of_coins -= 1
		goblin_score += 1
	
func _on_boost_collected():
	$BoostTimer.start()
	$Player.speed = 400
	
func game_over(winner):
	game_end.emit(winner)
	clear_all_coins()
	clear_all_boosts()
	$HUD/MessageLabel.show()
	if (winner == "Player"):
		$HUD.update_message("You won!")
	elif (winner == "Goblin"):
		$HUD.update_message("You lose!")
		
func get_number_of_coins_to_start():
	var base_coins = coins_to_win / 2
	var remainder_coins = coins_to_win % 2
	return (base_coins * 4) + (remainder_coins * 4)
	
func clear_all_coins():
	get_tree().call_group("Coins", "queue_free")

func clear_all_boosts():
	get_tree().call_group("Boosts", "queue_free")

func spawn_coins_and_hide():
	var screen_size = get_viewport_rect().size
	var screen_origin = get_viewport_rect().position
	set_q0_spawn_area()
	
	for i in 4:
		var coins_per_quadrant = starting_coins / 4
		print(coins_per_quadrant)
	
		for n in coins_per_quadrant:
			var coin = coin_scene.instantiate()
			var randomX = get_rand_in_quadrant(i)[0]
			var randomY = get_rand_in_quadrant(i)[1]
			
			var coin_spawn_location = Vector2(randomX, randomY)
	
			coin.position = coin_spawn_location
			number_of_coins += 1
			coin.name = "Coin " + str(number_of_coins)
			
			add_child(coin)
	
			get_node("Coin " + str(number_of_coins)).add_to_group("Coins")
			get_node("Coin " + str(number_of_coins)).coin_collected.connect(_on_coin_collected)
			get_node("Coin " + str(number_of_coins)).hide()

func get_rand_in_quadrant(quadrant):
	var screen_size = get_viewport_rect().size
	var screen_origin = get_viewport_rect().position
	var score_x = $HUD/ScoreImage.get_rect().size.x
	var score_y = $HUD/ScoreImage.get_rect().size.y
	
	var randX = 0
	var randY = 0
	
	match quadrant:
		0:
			if (randi() % 2):
				randX = randf_range(score_x, ( screen_size.x / 2 ))
				randY = randf_range(screen_origin.y, ( screen_size.y / 2 ))
				print("one")
			else:
				randX = randf_range(screen_origin.x, ( screen_size.x / 2 ))
				randY = randf_range(score_y, ( screen_size.y / 2 ))
				print("zero")
		1:
			randX = randf_range(( screen_size.x / 2 ), screen_size.x)
			randY = randf_range(screen_origin.y, ( screen_size.y / 2 ))
		2:
			randX = randf_range(( screen_size.x / 2 ), screen_size.x)
			randY = randf_range(( screen_size.y / 2 ), screen_size.y)
		3:
			randX = randf_range(screen_origin.x, ( screen_size.x / 2 ))
			randY = randf_range(( screen_size.y / 2 ), screen_size.y)
			
	return [randX, randY]
	

func spawn_boost():
	var screen_size = get_viewport_rect().size
	var screen_origin = get_viewport_rect().position
	
	var boost = boost_scene.instantiate()
	
	var randomX = randf_range(screen_origin.x, screen_size.x)
	var randomY = randf_range(screen_origin.y, screen_size.y)
	
	var boost_spawn_location = Vector2(randomX, randomY)
	
	boost.position = boost_spawn_location
	boost.name = "Boost"
	
	add_child(boost)
	
	get_node("Boost").add_to_group("Boosts")
	get_node("Boost").boost_collected.connect(_on_boost_collected)

func show_coins():
	get_tree().call_group("Coins", "show")
	
func set_q0_spawn_area():
	var screen_size = get_viewport_rect().size
	var screen_origin = get_viewport_rect().position
	var score_x = $HUD/ScoreImage.get_rect().size.x
	var score_y = $HUD/ScoreImage.get_rect().size.y
	var points = [
			Vector2(score_x, screen_origin.y),
			Vector2((screen_size.x / 2), screen_origin.y),
			Vector2((screen_size.x / 2), (screen_size.y / 2)),
			Vector2(screen_origin.x, (screen_size.y / 2)),
			Vector2(screen_origin.x, score_y),
			Vector2(score_x, score_y)
		]
	$SpawnArea.polygon = points
	$SpawnArea.color = Color(1, 1, 1, 0)

func reset_game():
	get_tree().reload_current_scene()

func _on_hud_start_game():
	player_score = 0
	goblin_score = 0
	$HUD.update_score(player_score)
	game_active.emit()
	show_coins()
	spawn_boost()
