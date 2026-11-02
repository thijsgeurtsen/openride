import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openride/main.dart';

void main() {
  testWidgets('routes and workout tabs are available', (tester) async {
    await tester.pumpWidget(const OpenRideApp());
    expect(find.text('Routes'), findsOneWidget);
    await tester.tap(find.text('Trainingen'));
    await tester.pumpAndSettle();
    expect(find.text('Tempo-training · 35 minuten'), findsOneWidget);
    expect(find.byKey(const Key('target-watts')), findsOneWidget);
  });
}
