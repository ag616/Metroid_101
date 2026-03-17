extends CharacterBody2D
var drone_dir: Vector2 = Vector2.ZERO #direction of the drone
var drone_speed:int = 50 #speed of the drone
var mark_enemy:bool = false #flag to see if the enemy is marked
var target: CharacterBody2D = null #make a variable for characterbody2d object - THIS ALWAYS CREATES A REFERENCE
var patrol_positions: Array[Vector2] =[]


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
	mark_enemy = true
	target = body #update the reference object - this stores the player node

func _on_agro_range_body_exited(_body: Node2D) -> void:
	mark_enemy = false
	drone_dir = Vector2.ZERO
	

func _physics_process(_delta: float) -> void:
	#need to move towards player
	if mark_enemy:
		#drone_dir = (target.global_position - global_position).normalized() #get the PV 
		drone_dir = to_local(nav_agent.get_next_path_position()).normalized()
	else:
		idle_patrol()
		drone_dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = drone_dir*drone_speed
	move_and_slide()
	
func _on_nav_refresh_timer_timeout() -> void:
	if mark_enemy:
		nav_agent.target_position = target.global_position

func idle_patrol():
	var patrol_point:Vector2 = patrol_positions.pick_random()
	if !mark_enemy and nav_agent.is_navigation_finished():
		nav_agent.target_position = patrol_point
