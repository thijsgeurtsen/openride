# OpenRide architecture / roadmap

## Target platforms
- Flutter: Windows and iPad (iOS). UI and ride domain logic shared.
- BLE: implement native/platform-specific FTMS adapters; validate actual trainer firmware and supported GATT characteristics on the KICKR CORE.
- Windows BLE: WinRT / Windows.Devices.Bluetooth via a Flutter plugin or method channel.
- iOS BLE: CoreBluetooth via a Flutter plugin or method channel; add Bluetooth usage description to Info.plist.
- Only one active trainer controller at a time. Avoid simultaneous trainer control from other cycling apps.

## FTMS integration plan (not implemented)
1. Scan and connect to KICKR CORE.
2. Discover FTMS (0x1826), Indoor Bike Data (0x2AD2), Fitness Machine Control Point (0x2AD9), supported features.
3. Parse flags and optional fields defensively, subscribe to notifications, and expose watts/cadence/speed.
4. Request control, verify control-point responses, then enable supported resistance/simulation commands. Implement safe disconnect/reconnect and fail-safe behavior.
5. Test on actual KICKR CORE before enabling control in a production build.

## Data flow
Trainer BLE -> FTMS adapter -> telemetry stream -> ride session -> UI + local recording -> FIT encoder -> optional secure Strava backend.
Route geometry/elevation -> grade calculation -> supported FTMS simulation/resistance control (after validation).

## Milestones
- M0: Demo UI, simulated ride, widget test (included).
- M1: Windows BLE discovery and telemetry (real device testing).
- M2: iPad BLE discovery and telemetry (requires Apple build/signing setup).
- M3: Safe resistance control, local ride persistence.
- M4: GPX routes, elevation profile, simulated physics.
- M5: FIT export + server-side Strava OAuth and upload.
- M6: 3D/real-video routes, multiplayer (later).

## Safety/privacy
No trainer commands in M0. User controls starting/stopping. Do not publish private tokens or ride locations. Keep Strava client secret server-side. Review third-party map/video licensing.

## Workout module (v0.2)

`lib/workouts.dart` bevat het platformonafhankelijke workout-model (duur, FTP-percentage en doelwattage) en intervalselectie. `WorkoutScreen` toont een demo-timer en een trainingsprofiel. Later wordt een `TrainerController` toegevoegd met een expliciete toestand (`disconnected`, `readOnly`, `erg`, `simulation`) zodat ERG en hellingssimulatie nooit tegelijk de trainer aansturen. ERG-doelen moeten worden begrensd en alleen na gebruikersactie en een geslaagde FTMS-featurecheck worden verzonden. Strava blijft een toekomstige backend-integratie, niet actief in v0.2.
