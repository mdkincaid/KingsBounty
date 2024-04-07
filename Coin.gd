extends Node2D

signal coin_collected(collector)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.name == "Player":
		queue_free()
		coin_collected.emit("Player")
		$CollisionShape2D.set_deferred("disabled", true)
	if area.name == "Goblin":
		queue_free()
		coin_collected.emit("Goblin")
		$CollisionShape2D.set_deferred("disabled", true)
	
