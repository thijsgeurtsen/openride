import 'package:flutter/foundation.dart';

@immutable
class WorkoutStep {
  final String name;
  final int seconds;
  final double ftpFraction;
  const WorkoutStep(this.name, this.seconds, this.ftpFraction);
  int targetWatts(int ftp) => (ftp * ftpFraction).round();
}

const tempoWorkout = <WorkoutStep>[
  WorkoutStep('Warming-up', 600, .55),
  WorkoutStep('Tempo 1', 480, .85),
  WorkoutStep('Herstel', 240, .50),
  WorkoutStep('Tempo 2', 480, .85),
  WorkoutStep('Cooling-down', 300, .45),
];

int get workoutDuration => tempoWorkout.fold(0, (sum, step) => sum + step.seconds);

({WorkoutStep step, int remaining, int index}) workoutAt(int elapsed) {
  var start = 0;
  for (var i = 0; i < tempoWorkout.length; i++) {
    final step = tempoWorkout[i];
    if (elapsed < start + step.seconds) {
      return (step: step, remaining: start + step.seconds - elapsed, index: i);
    }
    start += step.seconds;
  }
  return (step: tempoWorkout.last, remaining: 0, index: tempoWorkout.length - 1);
}

String clock(int seconds) => '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
