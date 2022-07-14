import 'package:proceduralclicker/game.dart';

class Shop {
  final List<WorkerData> _workers = [];
  bool isInited = false;

  Shop() {
    _generate();
  }

  void _generate() {
    const List<String> characters = [
      "assets/characters/goblin",
      "assets/characters/fish",
      "assets/characters/goat",
      "assets/characters/skeleton",
      "assets/characters/slime",
      "assets/characters/tomato",
      "assets/characters/fire",
      "assets/characters/statue",
      "assets/characters/blackberry",
      "assets/characters/tree",
      "assets/characters/cloud",
      "assets/characters/chicken",
      "assets/characters/bot",
      "assets/characters/goldenbot",
      "assets/characters/star",
    ];
    const List<String> hats = [
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
      "assets/hats/placeholder",
    ];
    const List<String> leftArms = [
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
      "assets/arms/leftplaceholder",
    ];
    const List<String> rightArms = [
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
      "assets/arms/rightplaceholder",
    ];
    double value = 100;
    int index = 0;
    for (int ci = 0; ci < characters.length; ci++) {
      for (int hi = 0; hi < hats.length; hi++) {
        for (int li = 0; li < leftArms.length; li++) {
          for (int ri = 0; ri < rightArms.length; ri++) {
            _workers.add(WorkerData(
              index++,
              value / 100,
              value,
              characters[ci],
              hats[hi],
              leftArms[li],
              rightArms[ri],
            ));
            value *= 1.01;
          }
          value *= 1.01;
        }
        value *= 1.01;
      }
      value *= 1.01;
    }
    isInited = true;
  }

  WorkerData getWorkerListByWealth(double wealth) {
    if (!isInited) {
      _generate();
    }

    int i = 0;
    while (_workers[i + 1].price <= wealth) {
      i++;
    }
    return _workers[i];
  }
}
