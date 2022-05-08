import 'package:flutter/material.dart';

class StressRelaese extends StatelessWidget {
  const StressRelaese({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Release Stress',
        ),
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'What is stress?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Stress is your body’s way of responding to any kind of demand or threat. When you sense danger—whether it’s real or imagined—the body’s defenses kick into high gear in a rapid, automatic process known as the “fight-or-flight” reaction or the “stress response.',
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'The stress response is the body’s way of protecting you. When working properly, it helps you stay focused, energetic, and alert. In emergency situations, stress can save your life—giving you extra strength to defend yourself, for example, or spurring you to slam on the brakes to avoid a car accident.',
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Stress can also help you rise to meet challenges. It’s what keeps you on your toes during a presentation at work, sharpens your concentration when you’re attempting the game-winning free throw, or drives you to study for an exam when you’d rather be watching TV. But beyond a certain point, stress stops being helpful and starts causing major damage to your health, mood, productivity, relationships, and your quality of life.',
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'If you frequently find yourself feeling frazzled and overwhelmed, it’s time to take action to bring your nervous system back into balance. You can protect yourself—and improve how you think and feel—by learning how to recognize the signs and symptoms of chronic stress and taking steps to reduce its harmful effects.',
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
