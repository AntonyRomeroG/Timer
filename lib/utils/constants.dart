import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_status.dart';

int pomodoroTotalTime = 25 * 60;
int shortBreakTime = 5 * 60;
int longBreakTime = 10 * 60;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runingPomodoro: 'Do as much as you can!',
  PomodoroStatus.pausedPomodoro: 'Start focused work!',
  PomodoroStatus.runningShortBreak: 'Take a short break!',
  PomodoroStatus.pausedShortBreak: 'Start short break',
  PomodoroStatus.runningLongBreak: 'Relax, you deserve it!',
  PomodoroStatus.pausedLongBreak: 'Start long break',
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runingPomodoro: Colors.red,
  PomodoroStatus.pausedPomodoro: Colors.grey,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.grey,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.grey,
};