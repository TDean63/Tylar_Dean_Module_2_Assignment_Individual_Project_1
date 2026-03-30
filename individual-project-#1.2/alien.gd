extends CharacterBody2D

const SPEED = 25.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_alive = true
var direction = 1

@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = -SPEED
	
	
	update_animation()
	move_and_slide()

func update_animation():
	animated_sprite_2d.play("move")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_alive
		queue_free()	
