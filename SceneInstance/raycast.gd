extends RayCast3D

@export var laser_length: float = 1.0


func _ready() -> void:
	enabled = true  # Enable RayCast3D
	target_position = Vector3(0, 0, -laser_length)  # Set the ray's length and direction

func _process(delta: float) -> void:
	pass
