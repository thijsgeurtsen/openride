# OpenRide — starter v0.1

Indoor cycling app prototype for **Windows** and **iPad**, intended for a **Wahoo KICKR CORE**.

**Current status:** Working Flutter *demo UI with simulated telemetry* only. It does **not** connect to the KICKR CORE, adjust resistance, save FIT, or upload to Strava yet. Those are documented milestones, not implemented features.

## Run on Windows
1. Install Flutter SDK, Git, Visual Studio 2022 with **Desktop development with C++** workload.
2. Create the platform scaffolding in this folder: `flutter create --platforms=windows,ios .` (generates missing Windows/iOS folders).
3. `flutter pub get`
4. `flutter run -d windows`
5. `flutter test`

## Run on iPad
Flutter iOS builds require **macOS with Xcode**, Apple signing, and a connected iPad or distribution through TestFlight. Windows alone cannot compile an iOS app. On a Mac: `flutter create --platforms=windows,ios .`, then `flutter run -d <your-ios-device-id>` after Xcode signing setup.

## GitHub
Create an empty repository named `openride`, then from this folder:
```
git init
git add .
git commit -m "Initial OpenRide Flutter demo"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/openride.git
git push -u origin main
```

## Architecture and next steps
See `docs/ARCHITECTURE.md`. Backend placeholder in `backend/README.md`.

## Notes
A Bluetooth connection may be held by another app. Close Zwift, ROUVY, Wahoo etc. before testing exclusive trainer control. Always test trainer control at low resistance with a safe stop path.

## Nieuw in v0.2: Trainingen

- Tabblad **Trainingen** naast **Routes**.
- Instelbare FTP (100–400 W), standaard 250 W.
- Tempo-workout van 35 minuten met vijf blokken, visueel trainingsprofiel en doelvermogen.
- Demo-timer met starten, pauzeren, hervatten en resetten.
- Tests voor de trainingslogica en het tabblad.

**Veiligheidsgrens:** dit is een simulator. De app verstuurt nog geen Bluetooth FTMS/ERG-opdrachten naar een KICKR CORE. Er is nog geen routekaart, FIT-export of Strava-synchronisatie geïmplementeerd.

### Installeren en starten

Installeer Flutter en de Windows desktop toolchain. Voer in deze map uit:

```bash
flutter create --platforms=windows,ios .
flutter pub get
flutter test
flutter run -d windows
```

iPad-builds vereisen macOS met Xcode. Voor een echte trainerverbinding volgt een platformgebonden Bluetooth-adapter, met controles voor FTMS-ondersteuning, exclusief besturingsrecht en veilige limieten voor doelvermogen.
