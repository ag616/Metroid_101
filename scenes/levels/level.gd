extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/Bullets/bullet.tscn") #select the bullet scene
var power_up: PackedScene = preload("res://scenes/entities/power_up.tscn") #select the power up scene

func _ready() -> void:
	$Entities/PowerUp.position = Vector2(1000,-20)

func _physics_process(_delta: float) -> void:
	if !$PowerUpTimer.time_left:
		$Entities/Player.speed = 100
		$Entities/Player/ReloadTimer.wait_time = 0.25
		$Entities/Player.is_power_up_on = false

func _on_player_shoot_signal(pos: Vector2, dir: Vector2) -> void:
	var bullet_scene_inst: = bullet_scene.instantiate() as Area2D
	#print("firing bullet")
	bullet_scene_inst.bullet_setup(pos,dir)
	var rot_angle = rad_to_deg(acos(dir.x))
	#print(rot_angle)
	bullet_scene_inst.rotation_degrees=rot_angle
	#var bullet_tween = get_tree().create_tween() Apparently its better to do this inside the bullet scene
	#bullet_scene_inst.scale = Vector2(0,0)
	#bullet_tween.tween_property(bullet_scene_inst,"scale",Vector2(1,1),0.2)
	$Bullets.add_child(bullet_scene_inst)

func buff_player():
	$PowerUpTimer.start()
	$Entities/Player.speed = 150
	$Entities/Player/ReloadTimer.wait_time = 0.15
	$Entities/Player.is_power_up_on = true #set the flag to true

	
func _on_power_up_body_entered(_body: Node2D) -> void:
	buff_player()
	$Entities/PowerUp.queue_free()
	
