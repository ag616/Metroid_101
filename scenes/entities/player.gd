extends CharacterBody2D

var direction_x:float = 0.0
var speed: int = 100
@export var jump_strength:= 200
@export var gravity: = 500
var reload: bool = false
signal shoot_signal(pos: Vector2, dir: Vector2)
const torso_direction = {
	Vector2i(1,0): 0,
	Vector2i(1,1): 1,
	Vector2i(0,1): 2,
	Vector2i(-1,1): 3,
	Vector2i(-1,0): 4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1): 6,
	Vector2i(1,-1): 7
}

@onready var stand_check: ShapeCast2D = $StandCollisionCheck
var is_crouching := false
var is_power_up_on := false


func get_input(): #easier way to get inputs
	direction_x = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y=-jump_strength*Input.get_action_raw_strength("jump")
	if Input.is_action_pressed("shoot") and $ReloadTimer.time_left==0:
		$AudioStreamPlayer2D.play()
		shoot_signal.emit(position,get_local_mouse_position().normalized())
		$ReloadTimer.start()
	if Input.is_action_pressed("crouch") and is_on_floor():
		enter_crouch()
	else:
		try_exit_crouch()
		
	
func apply_gravity(delta):
	velocity.y+=gravity*delta

func enter_crouch():
	if is_crouching:
		return
	is_crouching = true
	$Torso.position = Vector2(0,4)
	$CollisionShape2D.disabled = true
	speed=50
func try_exit_crouch():
	if !is_crouching:
		return
	# Check whether the standing shape would collide
	stand_check.force_shapecast_update() #Compute the physics update ahead of time before func _process.
	if stand_check.is_colliding(): #check if a collision instance would've taken place
		#Not enough room to stand
		return
	is_crouching = false #if there is room to stand, set the crouching flag to zero and attempt to stand
	$Torso.position = Vector2(0,-3) #set the torso back up
	$CollisionShape2D.disabled = false #enable the actual collision shape now
	speed = 100 #reset the speed to 100
		

func get_input2(): #this is how I coded for the first time
	if Input.is_action_pressed("left",true):
		speed = 100
		direction_x=-1
	elif Input.is_action_pressed("right",true):
		speed = 100
		direction_x=1
	elif Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		speed=0

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	update_marker()
	get_input()
	velocity.x=speed*direction_x
	move_and_slide()
	animate_player()
	#print(get_local_mouse_position().normalized())
	
func animate_player():
	#if direction_x!=0:
		#if direction_x==1:
			#$Legs.flip_h = false
			#$AnimationPlayer.play("run")
		#else:
			#$Legs.flip_h = true
			#$AnimationPlayer.play("run")
	#else:
		#$AnimationPlayer.play("idle_animation")
	#More elegant way to achieve the same thing:
	$Torso.frame = 0
	if !is_power_up_on:
		if is_on_floor():
			$Legs.flip_h = direction_x < 0
			$AnimationPlayer.current_animation = "run" if direction_x else "idle_animation"
		elif Input.is_action_pressed("jump") and !is_on_floor():
			$AnimationPlayer.current_animation = "jump_animation"
		elif !is_on_floor():
				$AnimationPlayer.current_animation = "jump_animation"
	else:
		if is_on_floor():
			$Legs.flip_h = direction_x < 0
			$AnimationPlayer.current_animation = "power_up_run" if direction_x else "idle_animation"
		elif Input.is_action_pressed("jump") and !is_on_floor():
			$AnimationPlayer.current_animation = "jump_animation"
		elif !is_on_floor():
				$AnimationPlayer.current_animation = "jump_animation"
	
	
	

	var mouse_direction: Vector2 = get_local_mouse_position().normalized()
	var mouse_direction_rounded:Vector2i = Vector2i(round(mouse_direction.x),round(mouse_direction.y))
	$Torso.frame = torso_direction[mouse_direction_rounded]
	
	
	
	#$Torso.flip_h = mouse_direction.x<0  THIS WAS MY METHOD 
	#if mouse_direction.y>=0.85:
		#$Torso.frame = 2
	#elif mouse_direction.y>0.5 and mouse_direction.y<0.85:
		#$Torso.frame = 1
	#elif mouse_direction.y>=-0.35 and mouse_direction.y<0.0:
		#$Torso.frame = 0
	#elif mouse_direction.y>=-0.85 and mouse_direction.y<-0.35:
		#$Torso.frame = 7
	#elif mouse_direction.y<-0.85:
		#$Torso.frame = 6

func update_marker():
	$Marker.position = get_local_mouse_position()
		

	
