extends Node

signal start_game
signal reset_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$MessageLabel.hide()
	$ResetButton.hide() 
	$ScoreLabel.hide() #
	$SpawnCoinsButton.hide() # 
	$TitleLabel.show() #
	$StartGameButton.show() #

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func update_message(message):
	$MessageLabel.text = message

func _on_spawn_coins_button_pressed():
	start_game.emit()

func _on_main_game_end(winner):
	$SpawnCoinsButton.hide()
	$ResetButton.show()

func _on_reset_button_pressed():
	reset_game.emit()

func _on_start_game_button_pressed():
	start_game.emit()
	$TitleLabel.hide()
	$StartGameButton.hide()
	$ScoreLabel.show()
