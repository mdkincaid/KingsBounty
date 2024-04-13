extends Node

signal start_game
signal reset_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$MessageLabel.hide()
	$ResetButton.hide()
	toggle_score(false)
	toggle_title(true)
	$SpawnCoinsButton.hide() # 
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
	
func toggle_title(isVisible):
	$TitleImage.visible = isVisible
	$TitleLabel.visible = isVisible
	
func toggle_score(isVisible):
	$ScoreLabel.visible = isVisible
	$ScoreImage.visible = isVisible

func _on_start_game_button_pressed():
	start_game.emit()
	toggle_title(false)
	toggle_score(true)
	$StartGameButton.hide()
