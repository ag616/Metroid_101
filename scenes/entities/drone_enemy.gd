extends CharacterBody2D


func _on_agro_range_body_entered(body: Node2D) -> void:
	if body
		print("Detecting")
		print(body)
