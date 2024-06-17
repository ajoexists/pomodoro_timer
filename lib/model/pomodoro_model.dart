class PomodoroModel {
  int workDuration;
  int breakDuration;
  bool isWorkTime;
  int remainingTime;
  bool isRunning;
  bool isSoundEnabled;

  PomodoroModel({
    required this.workDuration,
    required this.breakDuration,
    required this.isWorkTime,
    required this.remainingTime,
    required this.isRunning,
    this.isSoundEnabled = true,
  });

  void start() {
    isRunning = true;
  }

  void stop() {
    isRunning = false;
  }

  void reset() {
    remainingTime = isWorkTime ? workDuration : breakDuration;
    isRunning = false;
  }

  void tick() {
    if (isRunning) {
      remainingTime--;
      if (remainingTime <= 0) {
        isWorkTime = !isWorkTime;
        remainingTime = isWorkTime ? workDuration : breakDuration;
      }
    }
  }

  void updateWorkTime(int duration) {
    workDuration = duration;
    if (isWorkTime) {
      remainingTime = duration;
    }
  }

  void updateBreakTime(int duration) {
    breakDuration = duration;
    if (!isWorkTime) {
      remainingTime = duration;
    }
  }

  void toggleSound(bool isEnabled) {
    isSoundEnabled = isEnabled;
  }
}
