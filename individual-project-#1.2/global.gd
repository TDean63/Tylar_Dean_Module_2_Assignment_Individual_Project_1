extends Node

var total_specimen = 0
var player_lives = 3
enum PlayerState { SMALL, BIG, LAZER }
var current_state = PlayerState.SMALL

func spawn_battery(pos):
	var BatteryScene = load("res://battery.tscn")
	var battery = BatteryScene.instantiate()
	battery.global_position = pos
	get_tree().root.add_child(battery)

func spawn_lazer_power_up(pos):
	var LazerPowerUpScene = load("res://lazer_power_up.tscn")
	var lazer_power_up = LazerPowerUpScene.instantiate()
	lazer_power_up.global_position = pos
	get_tree().root.add_child(lazer_power_up)
