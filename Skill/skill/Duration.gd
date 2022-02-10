#==================================================
#	Duration.gd
#==================================================
#  持续性技能
# * 调用 control 方法进行施放
# * 扩展脚本时重写此脚本的 _process_duration 方法
#    进行添加持续性的功能
# * 调用 interrupt 方法提前中断技能，变为施放完成，和 
#    stop 方法的停止不同，stop 是强行中断正在施放的技能，
#    而 interrupt 则判定为技能已经施放完成了。
# * [ 请查看继承的 Skill.gd 的脚本的描述 ]
#==================================================
# @datetime: 2021-12-12 11:51:53
#==================================================

extends "Skill.gd"


## 开始执行持续技能
signal execute_duration


## 技能持续时间
export var duration : float = 1.0 setget set_duration


## 开始持续技能
var __executing__ : bool = false setget set_executing
## 持续时间计时器
var __duration_timer__ : Timer = Timer.new()



#==================================================
#   Set/Get
#==================================================
#(override)
func is_enabled() -> bool:
	return (.is_enabled()
		&& not __executing__
	)

##  设置持续时间
## @value  
func set_duration(value: float) -> void:
	duration = max(0.001, value)
	__duration_timer__.wait_time = duration

## 是否正在执行
func is_executing():
	return __executing__

func set_executing(value: bool):
	__executing__ = value
	set_physics_process(__executing__)



#==================================================
#   内置
#==================================================
func _ready():
	# 持续时间
	__duration_timer__.wait_time = duration
	__duration_timer__.one_shot = true
	__duration_timer__.autostart = false
	__duration_timer__.connect("timeout", self, "_duration_finished")
	self.add_child(__duration_timer__)


func _physics_process(delta):
	if __executing__:
		_process_duration(delta)



#==================================================
#   Skill 方法
#==================================================
#(override)
func _cast():
	._cast()
	__duration_timer__.stop()
	__duration_timer__.start(duration)
	__executing__ = true
	# 持续技能
	emit_signal("execute_duration")


#(override)
func _stop() -> bool:
	if ._stop():
		__duration_timer__.stop()
		__executing__ = false
		return true
	return false


#(override)
func _interrupt() -> int:
	if not __state__.is_no_cast():
		# 如果正在执行，则进行
		if __state__.is_casting():
			set_interrupt_state(Function.Skills.Signals.ExecuteDuration)
			_duration_finished()
			__duration_timer__.stop()
			__state__.casted()
			return InterruptResult.OK
		else:
			return ._interrupt()
	return InterruptResult.NO_EXECUTE


# ========================= [ 新添加 ] 

##  持续线程 
## @delta  帧时间
func _process_duration(_delta: float) -> void:
	pass


#(override)
func _executed():
	# 这个是在技能发出瞬间后进行处理的
	# 持续性施放之后的处理在 _duration_finished() 里进行
	pass


## 持续技能结束
func _duration_finished() -> void:
	__duration_timer__.stop()
	__executing__ = false
	if __refresh_timer__.is_stopped():
		__refresh_timer__.start()
	# 调用父类中的 executed (执行完成)方法 
	._executed()


