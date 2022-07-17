import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proceduralclicker/definitions.dart';
import 'package:proceduralclicker/rendering.dart';
import 'package:proceduralclicker/logic.dart';

class WorkerData {
  String character, leftArm, rightArm, hat;
  double cookiesPerSecond, price;
  int id;
  WorkerData([
    this.id = 0,
    this.cookiesPerSecond = 0,
    this.price = 0,
    this.character = "characters-placeholder",
    this.hat = "hats-placeholder",
    this.leftArm = "arms-leftplaceholder",
    this.rightArm = "arms-rightplaceholder",
  ]);
  @override
  String toString() =>
      "Id:$id - Price:$price - Generation:$cookiesPerSecond - $character - $leftArm - $rightArm - $hat";
}

class Game extends StatefulWidget {
  const Game({Key? key, this.refreshRate = 60}) : super(key: key);
  final int refreshRate;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<List<WorkerData?>> workers =
      List.generate(4, (i) => List.generate(3, (j) => null));
  Shop shop = Shop();
  int frame = 0;
  double cookies = 0;
  Timer? cookieTimer;

  @override
  void initState() {
    if (cookieTimer != null) cookieTimer!.cancel();
    cookieTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      for (var elem in workers) {
        for (var worker in elem) {
          if (worker != null) {
            cookies += worker.cookiesPerSecond / 10;
            setState(() {});
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (cookieTimer != null) cookieTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double shortestSize = MediaQuery.of(context).size.shortestSide;
    bool landscape =
        aspectRatio > 5 / 3 || aspectRatio <= 1 && aspectRatio > 3 / 5;
    double width = 1;
    double height = 1;
    if (aspectRatio > 5 / 3) {
      width = 4 / 3;
    } else if (aspectRatio > 1) {
      width = 3 / 4;
    } else if (aspectRatio > 3 / 5) {
      height = 3 / 4;
    } else {
      height = 4 / 3;
    }
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Containrr(
            size: Size(width * shortestSize, height * shortestSize),
            assetFolders: const [
              "assets/arms/",
              "assets/hats/",
              "assets/animations/",
              "assets/characters/",
              "assets/objects/",
              "assets/backgrounds/",
            ],
            elements: elements(landscape),
            relativeSize: true,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width -
                (aspectRatio > 1 ? width * shortestSize : 0),
            height: MediaQuery.of(context).size.height -
                (aspectRatio <= 1 ? height * shortestSize : 0),
            child: Column(
              children: [
                Text(
                  cookies < 1e9
                      ? cookies.toStringAsFixed(0)
                      : cookies.toStringAsExponential(3),
                  style: TextStyle(fontSize: RelSize(context).pixel * 48),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    cookies++;
                    for (var elem in workers) {
                      for (var worker in elem) {
                        if (worker != null) {
                          cookies += worker.cookiesPerSecond / 5;
                          setState(() {});
                        }
                      }
                    }
                  }),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width -
                            (aspectRatio > 1 ? width * shortestSize : 0),
                        height: MediaQuery.of(context).size.height -
                            (aspectRatio <= 1 ? height * shortestSize : 0) -
                            RelSize(context).pixel * 100,
                        child: Image.asset("assets/objects/cookie.png")),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<ContainrrElement> elements(bool landscape) {
    List<ContainrrElement> list = [];
    list.add(ContainrrElement(
      name: "assets/backgrounds/placeholder",
      size: Size(landscape ? 400 / 3 : 100, landscape ? 100 : 400 / 3),
    ));
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (workers[i][j] != null) {
          list.add(
            ContainrrElement(
              name: workers[i][j]!.character,
              size: const Size(13.3, 13.3),
              animationDuration: const Duration(milliseconds: 250),
              offset: Offset((landscape ? i : j) * 33.3 + 10,
                  (landscape ? j : i) * 33.3 + 4),
            ),
          );
          double workercookies = workers[i][j]!.cookiesPerSecond;
          list.add(
            ContainrrElement(
              name: "assets/objects/desk",
              size: const Size(23.3, 23.3),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 5,
                  (landscape ? j : i) * 33.3 + 10),
              overlay: Center(
                child: Text(
                  workercookies > 1e9
                      ? workercookies.toStringAsExponential(3)
                      : workercookies.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 24 * RelSize(context).pixel,
                  ),
                ),
              ),
            ),
          );
          list.add(
            ContainrrElement(
              name: "assets/animations/action",
              size: const Size(35, 35),
              firstAnimationFrame: 1,
              lastAnimationFrame: 24,
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 - 0.83,
                  (landscape ? j : i) * 33.3 - 6.5),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.rightArm,
              size: const Size(6.3, 9),
              offset: Offset((landscape ? i : j) * 33.3 + 9.5,
                  (landscape ? j : i) * 33.3 + 10),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.leftArm,
              size: const Size(6.3, 9),
              offset: Offset((landscape ? i : j) * 33.3 + 17.5,
                  (landscape ? j : i) * 33.3 + 10),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.hat,
              size: const Size(10, 10),
              lastAnimationFrame: -1,
              offset: Offset((landscape ? i : j) * 33.3 + 11.6,
                  (landscape ? j : i) * 33.3),
            ),
          );
          if (cookies > 1.1 * workers[i][j]!.price &&
              workers[i][j]!.id < 65536) {
            list.add(
              ContainrrElement(
                size: const Size(5, 5),
                offset: Offset((landscape ? i : j) * 33.3 + 24,
                    (landscape ? j : i) * 33.3),
                overlay: LayoutBuilder(builder: (context, constraints) {
                  return GestureDetector(
                    onTap: () {
                      characterTapDetector(i, j);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(Icons.upgrade, size: constraints.maxWidth),
                    ),
                  );
                }),
              ),
            );
          }
        } else {
          if (cookies >= 100) {
            list.add(
              ContainrrElement(
                size: const Size(33.3, 33.3),
                offset: Offset(
                    (landscape ? i : j) * 33.3, (landscape ? j : i) * 33.3),
                overlay: LayoutBuilder(builder: (context, constraints) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        characterTapDetector(i, j);
                      },
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Center(
                            child: Icon(
                          Icons.add_circle_outline,
                          size: constraints.maxWidth / 3,
                        )),
                      ),
                    ),
                  );
                }),
              ),
            );
          }
        }
      }
    }
    return list;
  }

  void characterTapDetector(int i, int j) {
    WorkerData availableWorker = shop.getWorkerListByWealth(cookies);

    if (availableWorker.price <= cookies &&
        (workers[i][j] == null ||
            workers[i][j]!.price * 1.01 <= availableWorker.price)) {
      cookies -= availableWorker.price;
      workers[i][j] = availableWorker;
    }
    setState(() {});
  }
}
