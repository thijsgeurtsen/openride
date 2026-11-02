import 'dart:async';
import 'package:flutter/material.dart';
import 'workouts.dart';

void main() => runApp(const OpenRideApp());

class OpenRideApp extends StatelessWidget {
  const OpenRideApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'OpenRide', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark), useMaterial3: true),
    home: const OpenRideHome(),
  );
}

class OpenRideHome extends StatelessWidget {
  const OpenRideHome({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(title: const Text('OpenRide · Prototype v0.2'),
        bottom: const TabBar(tabs: [Tab(icon: Icon(Icons.route), text: 'Routes'), Tab(icon: Icon(Icons.fitness_center), text: 'Trainingen')])),
      body: const TabBarView(children: [RideScreen(), WorkoutScreen()]),
    ),
  );
}

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});
  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  Timer? _timer;
  int seconds = 0;
  double distanceKm = 0;
  bool riding = false;
  int get watts => riding ? 165 + (seconds % 35) : 0;
  int get cadence => riding ? 82 + (seconds % 9) : 0;
  double get speed => riding ? 28.0 : 0.0;
  double get grade => seconds < 30 ? 0.0 : seconds < 90 ? 3.5 : 1.0;

  void toggle() {
    if (riding) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() { seconds++; distanceKm += 28.0 / 3600; });
      });
    }
    setState(() => riding = !riding);
  }
  void reset() { _timer?.cancel(); setState(() { riding = false; seconds = 0; distanceKm = 0; }); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final metrics = <(String, String, String)>[
      ('Vermogen', '$watts', 'W'), ('Cadans', '$cadence', 'rpm'),
      ('Snelheid', speed.toStringAsFixed(1), 'km/u'),
      ('Afstand', distanceKm.toStringAsFixed(2), 'km'),
      ('Helling (demo)', grade.toStringAsFixed(1), '%'),
      ('Tijd', clock(seconds), 'min:sec'),
    ];
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900),
      child: Padding(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(children: [
            Icon(Icons.terrain, size: 70, color: Colors.tealAccent),
            Text('Trainingsroute · simulatie', style: TextStyle(fontSize: 20)),
            Text('Geen echte trainerverbinding of weerstandsregeling actief.'),
          ]))),
          const SizedBox(height: 18),
          Expanded(child: GridView.count(crossAxisCount: MediaQuery.sizeOf(context).width < 600 ? 2 : 3,
            childAspectRatio: 1.45, mainAxisSpacing: 8, crossAxisSpacing: 8,
            children: metrics.map((m) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(m.$1), Text(m.$2, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.bold)), Text(m.$3),
            ]))).toList())),
          Wrap(spacing: 12, children: [
            FilledButton.icon(onPressed: toggle, icon: Icon(riding ? Icons.pause : Icons.play_arrow), label: Text(riding ? 'Pauzeren' : 'Start demo')),
            OutlinedButton(onPressed: reset, child: const Text('Reset')),
          ]),
        ],
      ))),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int ftp = 250;
  int elapsed = 0;
  bool running = false;
  Timer? _timer;

  void toggle() {
    if (running) {
      _timer?.cancel();
      setState(() => running = false);
    } else if (elapsed < workoutDuration) {
      setState(() => running = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          elapsed = (elapsed + 1).clamp(0, workoutDuration);
          if (elapsed == workoutDuration) { running = false; _timer?.cancel(); }
        });
      });
    }
  }
  void reset() { _timer?.cancel(); setState(() { running = false; elapsed = 0; }); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final active = workoutAt(elapsed);
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 850), child:
      ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Tempo-training · 35 minuten', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('DEMO · Geen Bluetooth-verbinding. ERG-commando’s worden nog niet naar de KICKR CORE gestuurd.'),
        const SizedBox(height: 18),
        Text('FTP: $ftp W', style: const TextStyle(fontSize: 18)),
        Slider(key: const Key('ftp-slider'), value: ftp.toDouble(), min: 100, max: 400, divisions: 60,
          label: '$ftp W', onChanged: running ? null : (value) => setState(() => ftp = value.round())),
        const SizedBox(height: 10),
        const Text('Trainingsprofiel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 135, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var i = 0; i < tempoWorkout.length; i++)
            Expanded(flex: tempoWorkout[i].seconds, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(height: 125 * tempoWorkout[i].ftpFraction,
                decoration: BoxDecoration(color: i == active.index ? Colors.tealAccent : Colors.teal.shade700,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4))))))
        ])),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Text(elapsed == workoutDuration ? 'Training voltooid' : active.step.name, style: const TextStyle(fontSize: 20)),
          Text('${active.step.targetWatts(ftp)} W', key: const Key('target-watts'), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
          Text('Resterend interval: ${clock(active.remaining)} · Totaal: ${clock(elapsed)} / ${clock(workoutDuration)}'),
          LinearProgressIndicator(value: elapsed / workoutDuration),
        ]))),
        const SizedBox(height: 12),
        for (final step in tempoWorkout)
          ListTile(dense: true, title: Text(step.name),
            subtitle: Text('${step.seconds ~/ 60} min · ${(step.ftpFraction * 100).round()}% FTP'),
            trailing: Text('${step.targetWatts(ftp)} W')),
        const SizedBox(height: 12),
        Wrap(spacing: 12, children: [
          FilledButton.icon(onPressed: elapsed == workoutDuration ? null : toggle,
            icon: Icon(running ? Icons.pause : Icons.play_arrow), label: Text(running ? 'Pauzeren' : 'Start training')),
          OutlinedButton(onPressed: reset, child: const Text('Reset training')),
        ]),
      ])));
  }
}
