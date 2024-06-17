import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/pomodoro_model.dart';

class PomodoroViewModel extends ChangeNotifier {
  final PomodoroModel _pomodoroModel = PomodoroModel(
    workDuration: 25 * 60, // Default to 25 minutes
    breakDuration: 5 * 60, // Default to 5 minutes
    isWorkTime: true, // Default to work time
    remainingTime: 25 * 60, // Default to 25 minutes
    isRunning: false, // Default to not running
  );
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  PomodoroModel get pomodoroModel => _pomodoroModel;

  void startTimer() {
    _pomodoroModel.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _pomodoroModel.tick();
      if (_pomodoroModel.remainingTime == 0) {
        if (_pomodoroModel.isSoundEnabled) {
          _playSound();
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void stopTimer() {
    _pomodoroModel.stop();
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    _pomodoroModel.reset();
    _timer?.cancel();
    notifyListeners();
  }

  void updateWorkTime(int minutes) {
    _pomodoroModel.updateWorkTime(minutes * 60);
    notifyListeners();
  }

  void updateBreakTime(int minutes) {
    _pomodoroModel.updateBreakTime(minutes * 60);
    notifyListeners();
  }

  void toggleSound(bool isEnabled) {
    _pomodoroModel.toggleSound(isEnabled);
    notifyListeners();
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('assets/sounds/pomodoro_notif.mp3'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
