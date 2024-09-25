import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pancakeCubit.dart';

void main() {
  runApp(const PancakeApp());
}

class PancakeApp extends StatelessWidget {
  const PancakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pancake App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => PancakeCubit(),
        child: const PancakeHomePage(),
      ),
    );
  }
}

class PancakeHomePage extends StatefulWidget {
  const PancakeHomePage({super.key});

  @override
  _PancakeHomePageState createState() => _PancakeHomePageState();
}

class _PancakeHomePageState extends State<PancakeHomePage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  void _createPancakes() {
    final count = int.tryParse(_controller.text);
    if (count != null && count >= 2 && count <= 15) {
      context.read<PancakeCubit>().initializePancakes(count);
      setState(() {
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = 'Please enter a number between 2 and 15';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pancake Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter number of pancakes (2-15)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createPancakes,
              child: const Text('Create Pancakes'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<PancakeCubit, List<Pancake>>(
                builder: (context, pancakes) {
                  if (pancakes.isEmpty) {
                    return const Center(child: Text('Enter a number to start'));
                  }
                  return Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ListView.builder(
                      itemCount: pancakes.length,
                      itemBuilder: (context, index) {
                        final pancake = pancakes[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<PancakeCubit>().flipPancakes(index);
                            if (context.read<PancakeCubit>().isSorted()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You won!')),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: pancake.length.toDouble(),
                                  constraints: BoxConstraints(maxWidth: Pancake.maxLength.toDouble()),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black), // Change border color to black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}