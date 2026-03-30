extends Sprite2D



func _on_ineraction_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.total_specimen += 1
		queue_free()
