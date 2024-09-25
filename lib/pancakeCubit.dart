import 'package:bloc/bloc.dart';
import 'dart:math';

class Pancake {
  final int length;
  static const int maxLength = 500; // Define maxLength here

  Pancake(this.length);
}

class PancakeCubit extends Cubit<List<Pancake>> {
  PancakeCubit() : super([]);

  void initializePancakes(int count) {
    final pancakes = List.generate(count, (index) => Pancake(min(50 + index * 30, Pancake.maxLength)));
    pancakes.shuffle(Random());
    emit(pancakes);
  }

  void flipPancakes(int index) {
    final pancakes = List<Pancake>.from(state);
    final flipped = pancakes.sublist(0, index + 1).reversed.toList();
    final remaining = pancakes.sublist(index + 1);
    emit([...flipped, ...remaining]);
  }

  bool isSorted() {
    for (int i = 0; i < state.length - 1; i++) {
      if (state[i].length > state[i + 1].length) {
        return false;
      }
    }
    return true;
  }

  void printPancakeWidths() {
    print("Pancake widths:");
    for (var pancake in state) {
      print(pancake.length);
    }
  }
}