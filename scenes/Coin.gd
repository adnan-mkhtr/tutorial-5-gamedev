extends Area2D

@onready var animated_sprite = $CoinAnimated


func _ready():
	add_to_group("coin")  # Tambahkan ke grup "coin"
	animated_sprite.play("coin")

func collect():
	queue_free()
