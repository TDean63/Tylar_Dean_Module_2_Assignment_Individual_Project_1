extends Area2D

var velocity = Vector2(500, 0)
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	add_to_group("lazer")
	animated_sprite.play("default")

func _physics_process(delta):
	self.position += velocity * delta

func _on_hitbox_body_entered(body):
	print("Laser hit:", body.name, " enemy? ", body.is_in_group("enemy"))
	if body.is_in_group("enemy"):
		body.queue_free()
		queue_free()
