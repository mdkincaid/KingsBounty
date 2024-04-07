extends Area2D

signal boost_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.name == "Player":
		queue_free()
		boost_collected.emit()
		$CollisionShape2D.set_deferred("disabled", true)
