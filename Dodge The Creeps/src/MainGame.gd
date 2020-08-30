extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

########
# Difficulty:
#   * "Im not in a risk group": covid resets, permits at least 1, mask at least 50%, 1 level retry
#   * "Resfriadinho":  covid resets, 1 level retry except first
#   * "Im legend": whatever you got in a level, is what you get in the next, no retrys
var difficulty
var level
var usercovid
var userpermits
var usermask
var level_retrys

# Called when the node enters the scene tree for the first time.
func _ready():
	usercovid = 0
	usermask = 0
	userpermits = 0
	level_retrys = 0
	$VBoxContainer/DifficultyContainer/Difficulty.add_item("I'm not in a risk group")
	$VBoxContainer/DifficultyContainer/Difficulty.add_item("Resfriadinho")
	$VBoxContainer/DifficultyContainer/Difficulty.add_item("I'm Legend")
	$VBoxContainer/DifficultyContainer/Difficulty.select(1)

func _on_Player_level_ended(covid, mask, permits):
	usercovid = covid
	usermask = mask
	userpermits = permits

func _on_Level_level_ended(covid, mask, permits):
	remove_child(level)
	$VBoxContainer.show()
	$VBoxContainer/Start.text = "Next Level"
	if difficulty == 0:
		usermask = max(50, mask)
		userpermits = max(1, permits)
	if difficulty <= 1:
		usercovid = 0
		level_retrys = 1
	$VBoxContainer/DifficultyContainer.hide()

func retryLevel():
	difficulty = $VBoxContainer/DifficultyContainer/Difficulty.get_selected_id()
	if difficulty == 0:
		usermask = max(50, usermask)
		userpermits = max(1, userpermits)
	level = load("scenes/LevelOne.tscn").instance()
	add_child(level)
	level.connect("level_ended", self, "_on_Level_level_ended")
	var player = level.get_node("LevelLayer/Player")
	player.covid = usercovid
	player.mask = usermask
	player.permits = userpermits
	#player.connect("end_level", self, "_on_Player_level_ended")
	player.connect("gameover", self, "_on_Player_gameovered")
	player.emit_signal("hit", usercovid, usermask)
	player.emit_signal("permit_update", userpermits)
	$VBoxContainer.hide()

func _on_Player_gameovered():
	remove_child(level)
	if level_retrys == 0:
		$VBoxContainer.show()
		$VBoxContainer/Title.text = "Game Over"
		$VBoxContainer/Start.text = "New Game"
		$VBoxContainer/DifficultyContainer.show()
	else:
		level_retrys -= 1
		retryLevel()

func _on_Start_pressed():
	difficulty = $VBoxContainer/DifficultyContainer/Difficulty.get_selected_id()
	if difficulty == 0:
		usermask = max(50, usermask)
		userpermits = max(1, userpermits)
		level_retrys = 1
	level = load("scenes/LevelOne.tscn").instance()
	add_child(level)
	level.connect("level_ended", self, "_on_Level_level_ended")
	var player = level.get_node("LevelLayer/Player")
	player.covid = usercovid
	player.mask = usermask
	player.permits = userpermits
	#player.connect("end_level", self, "_on_Player_level_ended")
	player.connect("gameover", self, "_on_Player_gameovered")
	player.emit_signal("hit", usercovid, usermask)
	player.emit_signal("permit_update", userpermits)
	$VBoxContainer.hide()
