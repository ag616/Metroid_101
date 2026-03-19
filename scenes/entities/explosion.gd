extends Sprite2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	#$Sprite2D.scale = Vector2.ZERO
	tween.tween_property($".","frame",7,5).from(0)
func setup(pos: Vector2):
	position = pos
