extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGamebutton.grab_focus()



func _on_new_gamebutton_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_loadbutton_pressed():
	get_tree().change_scene()
	

func _on_quitbutton_pressed():
	get_tree().quit()
	


