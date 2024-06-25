# Script responsible for managing the UI and updating it based on button inputs.
# Doc: https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515
extends Control

const SAVE_PATH: String = "user://player_data.tres"
const SAVE_PATH_INI: String = "user://player_data.ini"

var data_dir: String = OS.get_user_data_dir()
var number: int = 0
@onready var number_label: Label = $VBoxContainerMain/Label # Only assign a node to the variable once its ready (initiated).

# Updating the label text.
func _ready():
	update_label(number_label, number)

func _process(_delta):
	update_label(number_label, number)

func update_label(label: Label, value: int):
	label.text = str(value)


# Updating variables based on button inputs.
func _on_subtract_button_pressed():
	number -= 1

func _on_add_button_pressed():
	number += 1

func _on_quit_button_pressed():
	get_tree().quit()

func _on_open_save_button_pressed():
	OS.shell_open(data_dir)


# Saving and loading (using resources).
func _on_save_button_pressed():
	var data: Resource = PlayerData.new() # Create an instance of the PlayerData class.
	data.save_number = number # Update the resource attribute with the current UI number.
	
	ResourceSaver.save(data, SAVE_PATH) # Save the updated attributes.
	
	# Uncomment for error validation.
	# var error = ResourceSaver.save(data, SAVE_PATH) # The resourcesaver will return 1 if the file couldn't be saved.
	# if error: print("Couldn't save file.")

func _on_load_button_pressed():
	if FileAccess.file_exists(SAVE_PATH): # If the save file exists, attempt to load the required data.
		var data: Resource = load(SAVE_PATH)
		number = data.save_number
	else:
		print("No save file found.")


# Saving and loading (using ini files).
func _on_save_button_ini_pressed():
	var ini_data: Variant = ConfigFile.new() # Create an instance of the ConfigFile class (inbuilt).
	ini_data.set_value("Player", "number", number)
	
	ini_data.save(SAVE_PATH_INI)
	
	# Uncomment for error validation.
	# var error = ini_data.set_value("Player", "number", number) # 1 will be returned if the file couldn't be saved.
	# if error: print("Couldn't save file.")

func _on_load_button_ini_pressed():
	if FileAccess.file_exists(SAVE_PATH_INI):
		var ini_data: Variant = ConfigFile.new()
		ini_data.load(SAVE_PATH_INI) # Validation can be added where 1 is returned if the file coudn't be loaded.
		number = ini_data.get_value("Player", "number", 0) # The fallback value is 0 even if the specified value isn't found in the ini file.
	else:
		print("No save file found.")

# To save with encryption, use save_encrypted_pass() instead of save(), where the passkey parameter is a string of your choice. Load using load_encrypted_pass instead of load().
