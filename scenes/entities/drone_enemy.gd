extends CharacterBody2D
var drone_dir: Vector2 = Vector2.ZERO #direction of the drone
var chasing_speed:int = 50 #speed of the drone while chasing
var mark_enemy:bool = false #flag to see if the enemy is marked
var target: CharacterBody2D = null #make a variable for characterbody2d object - THIS ALWAYS CREATES A REFERENCE
var patrol_positions: Array[Vector2] =[]
var chasing_distance: float = 200 #this is the chasing distance
var idle_speed: int = 25 #speed of drone while idling
var drone_speed: int = 0 #speed of the drone
var explosion_scene: PackedScene = preload("res://scenes/entities/explosion.tscn")
var hit_points: int = 3 #this is the hp of the drone


@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	for marker in $PatrolMarkers.get_children():
		if marker is Marker2D:
			patrol_positions.append(marker.global_position) #update marker positions
	

func update_marker_positions():
	var i =0
	for marker in $PatrolMarkers.get_children():
		patrol_positions[i] = marker.global_position
		i += 1
	

func _on_agro_range_body_entered(body: Node2D) -> void:
	drone_speed = chasing_speed
	mark_enemy = true
	target = body #update the reference object - this stores the player node
	nav_agent.target_position = target.global_position

func _on_agro_range_body_exited(_body: Node2D) -> void:
	drone_speed = idle_speed
	mark_enemy = false
	nav_agent.target_position = patrol_positions.pick_random()
	

func _physics_process(_delta: float) -> void:
	#need to move towards player
	#$DebugLabel.text = "Done:%s\n Hit target:%s \n Target reachable:%s" % [
		#nav_agent.is_navigation_finished(),
		#nav_agent.is_target_reached(),
		#nav_agent.is_target_reachable()
	#]
	if hit_points <=0:
		print("drone gonna die")
		animate_explosion()
	if mark_enemy and (nav_agent.get_path_length() <= chasing_distance):
		drone_speed = chasing_speed
		#drone_dir = (target.global_position - global_position).normalized() #get the PV 
		drone_dir = to_local(nav_agent.get_next_path_position()).normalized()
	else:
		idle_patrol()
		drone_dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	if target!=null:
		if (position-target.position).length() <= 15.0:
			print("going to collide")
			animate_explosion()
			#Need to display explosion animation
		
	velocity = drone_dir*drone_speed
	move_and_slide()

func animate_explosion():
	$Sprite2D.visible = false 
	#var explosion_scene_inst: = explosion_scene.instantiate() as Sprite2D
	#explosion_scene_inst.setup($Sprite2D.position)
	#$".".add_child(explosion_scene_inst)
	#queue_free()
	$animated_explosion.visible = true
	$animated_explosion.play("explosion_animation")
	#var tween = get_tree().create_tween()
	#tween.tween_property(explosion_scene_inst,"frame",7,5).from(0)

	

func _on_nav_refresh_timer_timeout() -> void:
	if mark_enemy:
		nav_agent.target_position = target.global_position

func idle_patrol():
	drone_speed = idle_speed
	var patrol_point:Vector2 = patrol_positions.pick_random()
	if !mark_enemy and nav_agent.is_navigation_finished():
		nav_agent.target_position = patrol_point


func _on_animated_explosion_animation_finished() -> void:
	queue_free()
