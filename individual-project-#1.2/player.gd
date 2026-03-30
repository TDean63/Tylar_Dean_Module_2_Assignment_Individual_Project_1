extends CharacterBody2D

var is_firing_lazer = false
var can_fire_lazer = false
var is_dying = false
var is_jumping = false
var is_big = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player_direction = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var death_timer = $death_timer
@onready var lazer_fire_timer = $LazerFireTimer

func _ready():
	add_to_group("player")
	death_timer.connect("timeout", Callable(self, "_on_DeathTimer_timeout"))
	lazer_fire_timer.connect("timeout", Callable(self, "_on_LazerFireTimer_timeout"))

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false

	if Global.current_state == Global.PlayerState.LAZER and Input.is_action_just_pressed("fire"):
		fire_lazer()

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation(direction)
	move_and_slide()

func update_animation(direction):
	if is_dying or is_firing_lazer:
		return
		
	match Global.current_state:
		Global.PlayerState.SMALL, Global.PlayerState.BIG:
			if is_jumping:
				animated_sprite_2d.play("jump")
			elif direction != 0:
				animated_sprite_2d.flip_h = (direction < 0)
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.play("idle")
		Global.PlayerState.LAZER:
			if is_jumping:
				animated_sprite_2d.play("lazer_jump")
			elif direction != 0:
				animated_sprite_2d.flip_h = (direction < 0)
				animated_sprite_2d.play("lazer_run")
			else:
				animated_sprite_2d.play("lazer_idle")
		



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body.is_alive:
		match Global.current_state:
			Global.PlayerState.SMALL:
				die()
			Global.PlayerState.BIG:
				Global.current_state = Global.PlayerState.SMALL
			Global.PlayerState.LAZER:
				Global.current_state = Global.PlayerState.BIG
		
func die():
	if is_dying:
		return
		
	is_dying = true
	animated_sprite_2d.play("die")
	await move_player_up_and_down()
	Global.player_lives -= 1
	
	if Global.player_lives > 0:
		print("Reloading Scene")
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://gameover.tscn")
	
func move_player_up_and_down():
	var start_position = position
	var up_position = start_position + Vector2(0, -100)
	var down_position = start_position + Vector2(0, 600)
	
	while position.y > up_position.y:
		position.y -= 4
		await get_tree(). create_timer(0.01).timeout
		
	while position.y < down_position.y:
		position.y += 4
		await get_tree(). create_timer(0.01).timeout
		
func on_DeathTimer_timeout():
	get_tree().reload_current_scene()
	
func become_big():
	Global.current_state = Global.PlayerState.BIG
	self.scale = Vector2(1.5, 1.5)

func become_small():
	Global.current_state = Global.PlayerState.SMALL
	self.scale = Vector2(1,1)

func got_lazer():
	Global.current_state = Global.PlayerState.LAZER

func fire_lazer():
	is_firing_lazer = true
	print("firing lazer")
	var lazer = load("res://lazer.tscn").instantiate()
	lazer.global_position = Vector2(self.global_position.x, self.global_position.y - 15)
	
	lazer.set("velocity", Vector2(500 * player_direction, 0))
	print("Lazer Fired")
	get_parent().add_child(lazer)
	$AnimatedSprite2D.play("lazer_fire")
	lazer_fire_timer.start(0.5)

func _on_LazerFireTimer_timeout():
	is_firing_lazer = false
