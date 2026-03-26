extends Area2D

var fire_direction: Vector2 = Vector2.ZERO
var bullet_speed: int = 150

func _ready() -> void:
	var tween = get_tree().create_tween()
	#$Sprite2D.scale = Vector2.ZERO
	tween.tween_property($Sprite2D,"scale",Vector2.ONE,1).from(Vector2.ZERO)

func bullet_setup(pos: Vector2, dir: Vector2):
	position = pos
	fire_direction=dir

func _process(delta: float) -> void:
	position+=150*fire_direction*delta
	

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.hit_points -=1
		var drone_sprite = body.get_node("AnimatedSprite2D")
		var hit_tween = get_tree().create_tween()
		hit_tween.set_loops(1)
		hit_tween.tween_property(drone_sprite.material,"shader_parameter/Progress",0,0.1)
		hit_tween.tween_property(drone_sprite.material,"shader_parameter/Progress",1,0.2)
		#drone_sprite.material.set_shader_parameter('Progress',0.0)
		
	queue_free()
		
