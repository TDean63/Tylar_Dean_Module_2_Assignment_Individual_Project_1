extends CanvasLayer

func _process(delta):
	$Label.text = "Specimen Collected: " + str(Global.total_specimen)
	$Label2.text = "Lives: " + str(Global.player_lives)
