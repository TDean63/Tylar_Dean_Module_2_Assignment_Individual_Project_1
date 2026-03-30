extends Area2D


func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.current_state = Global.PlayerState.LAZER
		self.queue_free()
