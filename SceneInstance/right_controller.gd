extends XRController3D

var active_Collider = null
@onready var right_controller_audio = $RightController/AudioStreamPlayer3D

func _ready() -> void:
	# Ensure RayCast3D is enabled and find the RayCast3D node in the controller
	if $"MeshInstance3D/RayCast3D" != null:
		$"MeshInstance3D/RayCast3D".enabled = true  # Enable RayCast3D
	else:
		print("RayCast3D not found!")

func _process(delta: float) -> void:
	# Check if RayCast3D is colliding with any object
	if $"MeshInstance3D/RayCast3D".is_colliding():
		var current_Collider = $"MeshInstance3D/RayCast3D".get_collider()

		# Only proceed if it's a new collider or different from the previous one
		if active_Collider == null or active_Collider != current_Collider:
			active_Collider = current_Collider

			# Get the parent of the collider (which should be the cube)
			var cube = current_Collider.get_parent()

			# Assuming the cube has a method called 'split_cube()'
			if cube.has_method("split_cube"):
				cube.split_cube() 
				$"beep".play()
