import 'package:flutter_test/flutter_test.dart';
import 'package:openride/workouts.dart';

void main() {
  test('tempo training is 35 minutes', () {
    expect(workoutDuration, 2100);
    expect(tempoWorkout.map((s) => s.targetWatts(250)).toList(), [138, 213, 125, 213, 113]);
  });
  test('interval boundaries and completion', () {
    expect(workoutAt(599).index, 0);
    expect(workoutAt(600).index, 1);
    expect(workoutAt(2100).remaining, 0);
  });
}
