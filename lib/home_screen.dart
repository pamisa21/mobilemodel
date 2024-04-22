import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ilisi nalang sad tingali ang design'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Text('Ayaw nalang sad siguro awata ang design no'),
            const SizedBox(height: 50,),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('/realtime');
              },
              child: Text('Realtime Camera')
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/image');
                },
                child: Text('Image Upload')
            )

          ],
        ),
      ),
    );
  }
}
