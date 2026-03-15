extends CharacterBody2D
var drone_dir: Vector2 = Vector2.ZERO #direction of the drone
var drone_speed:int = 50 #speed of the drone
var mark_enemy:bool = false #flag to see if the enemy is marked
var target: CharacterBody2D = null #make a variable for characterbody2d object - THIS ALWAYS CREATES A REFERENCE

func _on_agro_range_body_entered(body: Node2D) -> void:
	mark_enemy = true
	target = body #update the reference object - this stores the player node

func _on_agro_range_body_exited(_body: Node2D) -> void:
	mark_enemy = false
	drone_dir = Vector2.ZERO
	

func _physics_process(_delta: float) -> void:
	#need to move towards player
	if mark_enemy:
		drone_dir = (target.global_position - global_position).normalized() #get the PV 
	velocity = drone_dir*drone_speed
	move_and_slide()
	
