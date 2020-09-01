class_name PersonVisiblySick
extends Person

const Damage = preload("res://src/Damagable.gd")
var damage

func _init() -> void:
	default_sprite_name = "default"
	self.damage = Damage.new(.85)
	

func _ready() -> void: 
	_set_sprite_and_collision($AnimatedSprite, $Collision)


#func _process(delta: float) -> void:
#	_person_process(delta)


func init(new_position, direction) -> PersonVisiblySick:
	_init_person(new_position, direction)
	return self
