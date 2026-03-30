extends Control

func _on_tryagain_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
