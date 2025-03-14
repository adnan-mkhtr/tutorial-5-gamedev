extends Node2D

#@onready var bgm_player = $BackgroundStreamPlayer
@onready var bgm_player = $DownloadBackgroundStream


func _ready():
	if not bgm_player.playing:
		bgm_player.play()
