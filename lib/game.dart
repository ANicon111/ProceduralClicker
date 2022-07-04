import 'dart:async';

import 'package:flutter/material.dart';
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
      height = 1;
    } else if (aspectRatio > 3 / 5) {
      width = 1;
      height = 3 / 4;
    } else {
      height = 4 / 3;
    }
    return Stack(
      children: [
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
                Text(cookies < 1e9
                    ? cookies.toStringAsFixed(0)
                    : cookies.toStringAsExponential(5)),
                FloatingActionButton(
                    onPressed: () => setState(() {
                          cookies++;
                        }),
                    child: const Icon(Icons.add))
              ],
            ),
          ),
        ),
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
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 10,
                  (landscape ? j : i) * 33.3 + 4),
            ),
          );
          list.add(
            ContainrrElement(
              name: "assets/objects/desk",
              size: const Size(23.3, 23.3),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 5,
                  (landscape ? j : i) * 33.3 + 10),
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
              gestureDetector: GestureDetector(
                onTap: () {
                  characterTapDetector(i, j);
                },
                child: const MouseRegion(cursor: SystemMouseCursors.click),
              ),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.rightArm,
              size: const Size(6.3, 9),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 9.5,
                  (landscape ? j : i) * 33.3 + 10),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.leftArm,
              size: const Size(6.3, 9),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 17.5,
                  (landscape ? j : i) * 33.3 + 10),
            ),
          );
          list.add(
            ContainrrElement(
              name: workers[i][j]!.hat,
              size: const Size(10, 10),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset((landscape ? i : j) * 33.3 + 11.6,
                  (landscape ? j : i) * 33.3),
            ),
          );
        } else {
          list.add(
            ContainrrElement(
              name: "assets/objects/desk",
              size: const Size(33.3, 33.3),
              animationDuration: const Duration(milliseconds: 500),
              offset: Offset(
                  (landscape ? i : j) * 33.3, (landscape ? j : i) * 33.3),
              gestureDetector: GestureDetector(
                onTap: () {
                  characterTapDetector(i, j);
                },
              ),
            ),
          );
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

/*class Painter extends CustomPainter {
  final int frame;
  final List<List<WorkerData?>> workerGrid;
  bool landscape;

  Painter(this.frame, this.assets, this.workerGrid, this.landscape);

  @override
  void paint(Canvas canvas, Size size) {
    double pixel = size.shortestSide / 1080;
    if (assets.isInited) {
      image(
          canvas, "backgrounds-placeholder", 1, 0, 0, size.width, size.height);
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
          if (workerGrid[i][j] != null) {
            desk(
              canvas,
              landscape ? i : j,
              landscape ? j : i,
              pixel,
              workerGrid[i][j]!,
            );
          }
        }
      }
    }
    if (kDebugMode) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: frame.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 30 * pixel,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(size.width - textPainter.width, 0));
    }
  }

  void desk(Canvas canvas, int i, int j, double pixel, WorkerData worker) {
    workerPainter(
      canvas,
      i * 360 * pixel,
      j * 360 * pixel,
      pixel / 2.22222,
      "objects-desk",
      "animations-action",
      worker,
    );
  }

  void workerPainter(
    Canvas canvas,
    double x,
    double y,
    double scale,
    String desk,
    String animation,
    WorkerData worker,
  ) {
    image(canvas, worker.character, 1, x + 250 * scale, y + 100 * scale,
        300 * scale, 300 * scale);
    image(canvas, desk, 1, x + 150 * scale, y + 250 * scale, 500 * scale,
        500 * scale);
    image(canvas, animation, 15, x - 0 * scale, y - 135 * scale, 800 * scale,
        800 * scale);
    image(canvas, worker.rightArm, 1, x + 240 * scale, y + 250 * scale,
        140 * scale, 200 * scale);
    image(canvas, worker.leftArm, 1, x + 420 * scale, y + 250 * scale,
        140 * scale, 200 * scale);
    image(canvas, worker.hat, 1, x + 280 * scale, y + scale * 10, 240 * scale,
        240 * scale);
    final textPainter = TextPainter(
      text: TextSpan(
        text: worker.cookiesPerSecond < 1e8
            ? worker.cookiesPerSecond.toStringAsFixed(0)
            : worker.cookiesPerSecond
                .toStringAsExponential(5)
                .replaceAll("+", ""),
        style: TextStyle(
          color: Colors.white,
          fontSize: 64 * scale,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: 1000 * scale,
      );
    textPainter.paint(canvas,
        Offset(x + 400 * scale - textPainter.size.width / 2, y + 470 * scale));
  }

  void image(Canvas canvas, String name, int frameTimeMultiplier, double x,
      double y, double w, double h) {
    if (assets.get(name, frame ~/ frameTimeMultiplier) != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(x, y, w, h),
        image: assets.get(name, frame ~/ frameTimeMultiplier)!,
        fit: BoxFit.cover,
        repeat: ImageRepeat.noRepeat,
        scale: 1e-100,
        alignment: Alignment.center,
        flipHorizontally: false,
        filterQuality: FilterQuality.low,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
*/