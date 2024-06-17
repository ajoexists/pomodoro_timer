import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/pomodoro_view_model.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  PomodoroPageState createState() => PomodoroPageState();
}

class PomodoroPageState extends State<PomodoroPage> {
  int workTime = 25;
  int breakTime = 5;
  ValueNotifier<bool> isSoundEnabled = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Consumer<PomodoroViewModel>(
          builder: (context, viewModel, child) {
            final pomodoro = viewModel.pomodoroModel;
            final minutes = (pomodoro.remainingTime ~/ 60).toString().padLeft(2, '0');
            final seconds = (pomodoro.remainingTime % 60).toString().padLeft(2, '0');

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 130,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: pomodoro.isWorkTime
                          ? Colors.red.withOpacity(0.15)
                          : Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Center(
                    child: Text(
                      pomodoro.isWorkTime
                          ? "Work Time"
                          : "Break Time",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    Text(
                      "$minutes\n$seconds",
                      style: const TextStyle(
                        fontSize: 100,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 75,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              pomodoro.isWorkTime
                                  ? Colors.red.withOpacity(0.20)
                                  : Colors.green.withOpacity(0.20),
                            )
                        ),
                        onPressed: () {
                          _showSettingsDialog(context, viewModel);
                        },
                        child: const Icon(
                          Icons.more_horiz,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 50,
                      width: 80,
                      child: ElevatedButton(
                        onPressed: viewModel.pomodoroModel.isRunning
                            ? viewModel.stopTimer
                            : viewModel.startTimer,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              pomodoro.isWorkTime
                                  ? Colors.red
                                  : Colors.green,
                            )
                        ),
                        child: Center(
                          child: Icon(
                            viewModel.pomodoroModel.isRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 40,
                      width: 75,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              pomodoro.isWorkTime
                                  ? Colors.red.withOpacity(0.20)
                                  : Colors.green.withOpacity(0.20),
                            )
                        ),
                        onPressed: viewModel.resetTimer,
                        child: const Icon(
                          Icons.restart_alt,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, PomodoroViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Work Time (minutes)",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    Theme(
                      data: ThemeData(
                          canvasColor: Colors.black,
                          primaryColor: Colors.black,
                          hintColor: Colors.black
                      ),
                      child: DropdownButton<int>(
                        value: workTime,
                        items: [15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
                            .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            workTime = value!;
                            viewModel.updateWorkTime(workTime * 60);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Break Time (minutes)",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    Theme(
                      data: ThemeData(
                          canvasColor: Colors.black,
                          primaryColor: Colors.black,
                          hintColor: Colors.black,
                      ),
                      child: DropdownButton<int>(
                        value: breakTime,
                        items: [5, 10, 15, 20, 25, 30].map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            breakTime = value!;
                            viewModel.updateBreakTime(breakTime * 60);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Enable Sound",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isSoundEnabled,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: value,
                            onChanged: (newValue) {
                              isSoundEnabled.value = newValue;
                              viewModel.toggleSound(newValue); // Update the sound setting in the ViewModel
                            },
                            activeColor: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.blue
                  ),
                ),
              ),
            ],
        );
      },
    );
  }
}
