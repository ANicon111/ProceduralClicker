import 'package:proceduralclicker/game.dart';

class Shop {
  final List<WorkerData> workers = [];
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
      "assets/characters/ghost",
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
      "",
      "assets/hats/straw",
      "assets/hats/fedora",
      "assets/hats/whitefedora",
      "assets/hats/slime",
      "assets/hats/superhero",
      "assets/hats/toppat",
      "assets/hats/troll",
      "assets/hats/onion",
      "assets/hats/pride",
      "assets/hats/volt",
      "assets/hats/cookies",
      "assets/hats/alien",
      "assets/hats/aquarium",
      "assets/hats/halo",
      "assets/hats/flower",
    ];
    const List<String> leftArms = [
      "assets/arms/leftgoblin",
      "assets/arms/leftantena",
      "assets/arms/leftcloud",
      "assets/arms/leftgrapple",
      "assets/arms/leftleaf",
      "assets/arms/leftmagic",
      "assets/arms/leftpirate",
      "assets/arms/leftrobotclaw",
      "assets/arms/leftstars",
      "assets/arms/leftstickmin",
      "assets/arms/leftrobotdrill",
      "assets/arms/leftvine",
      "assets/arms/lefttree",
      "assets/arms/leftrobotdiamonddrill",
      "assets/arms/tankie",
      "assets/arms/ancom",
    ];
    const List<String> rightArms = [
      "assets/arms/rightgoblin",
      "assets/arms/rightantena",
      "assets/arms/rightcloud",
      "assets/arms/rightgrapple",
      "assets/arms/rightleaf",
      "assets/arms/rightmagic",
      "assets/arms/rightpirate",
      "assets/arms/rightrobotclaw",
      "assets/arms/rightstars",
      "assets/arms/rightstickmin",
      "assets/arms/rightrobotdrill",
      "assets/arms/rightvine",
      "assets/arms/righttree",
      "assets/arms/rightrobotdiamonddrill",
      "assets/arms/ancap",
      "assets/arms/fash",
    ];
    double value = 100;
    int index = 0;
    for (int ci = 0; ci < characters.length; ci++) {
      for (int hi = 0; hi < hats.length; hi++) {
        for (int li = 0; li < leftArms.length; li++) {
          for (int ri = 0; ri < rightArms.length; ri++) {
            workers.add(WorkerData(
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
    while (workers[i + 1].price <= wealth) {
      i++;
    }
    return workers[i];
  }
}
