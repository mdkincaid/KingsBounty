extends Area2D

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimationPlayer.play("walk_h")
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0 && velocity.y > 0:
		$AnimationPlayer.play("walk_d")
	elif velocity.y != 0 && velocity.y < 0:
		$AnimationPlayer.play("walk_u")

	if velocity == Vector2.ZERO:
		$AnimationPlayer.play("idle")
		
func _on_main_game_end(winner):
	set_process(false)
	if (winner == "Player"):
		$AnimationPlayer.play("dance")
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = false
	else:
		$AnimationPlayer.play("lose")
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = false
