#============================================================
#	Function
#============================================================
#  Function 全局功能
# * 方便使用，不用手动输入字符串，防止出错
#============================================================
# @datetime: 2022-2-5 14:33:48
#============================================================

class_name Function
extends Reference

# ========================= [ 常量 ] 

const Skills = {
	Signals = {
		ReadyExecute = 'ready_execute',			# 准备执行功能，开始执行前摇
		ExecuteDuration = 'execute_duration',	# 前摇执行结束，执行功能
		Executed = 'executed',					# 功能执行完成，开始执行后摇
		ExecuteFinished = 'execute_finished',	# 后摇执行结束，动作完全结束
		StatusRefreshed = 'status_refreshed',	# 功能冷却完成，可再次使用
		Interrupted = "interrupted",			# 技能被中断时发出
		Stopped = 'stopped',					# 停止执行功能时发出
	},
	Propertys = {
		BeforeShake = "before_shake",
		AfterShake = 'after_shake',
		Interval = 'interval',
		Duration = 'duration',
	}
}

static func get_skill_signal_list() -> Array:
	return Skills.Signals.values()

static func get_skill_property_list() -> Array:
	return Skills.Propertys.values()


