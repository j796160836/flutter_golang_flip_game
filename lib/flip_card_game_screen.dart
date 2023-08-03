import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_golang_flip_game/contants.dart';

class FlipCardGameScreen extends StatefulWidget {
  const FlipCardGameScreen({super.key});

  @override
  State<FlipCardGameScreen> createState() => _FlipCardGameScreenState();
}

class CardContent {
  final int value;
  final String content;

  CardContent(this.value, this.content);
}

class _FlipCardGameScreenState extends State<FlipCardGameScreen> {
  List<FlipCardController> _cardControllers = List.empty(growable: true);
  int _previousIndex = -1;
  bool _lockBoard = false;
  int _pairsFound = 0;
  Timer? _gameTimer;
  Timer? _flippedBackTimer;
  Duration _gameDuration = _gameTimeLimit;

  static const Duration _gameTimeLimit = Duration(seconds: 120);

  final List<CardContent> _cardItems = Constants.cardItems;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _cardControllers =
        List.generate(_cardItems.length, (index) => FlipCardController());
    _cardItems.shuffle(); // Randomly shuffle cards
    _previousIndex = -1;
    _lockBoard = false;
    _pairsFound = 0;
  }

  void _onCardTap(int index) {
    if (_lockBoard || _cardControllers[index].state?.isFront != true) return;

    setState(() {
      _gameTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        _gameDuration -= const Duration(seconds: 1);
        setState(() {});
        if (_gameDuration.inSeconds == 0) {
          timer.cancel();
          _showGameOverDialog();
        }
      });

      _cardControllers[index].toggleCard();
      if (_previousIndex != -1) {
        // Compare cards if a previous card is already flipped
        if (_cardItems[_previousIndex].value == _cardItems[index].value) {
          // Match found
          _pairsFound++;
          _previousIndex = -1;

          if (_pairsFound == _cardItems.length ~/ 2) {
            // All pairs found, show a dialog or perform any other action
            _gameTimer?.cancel();
            _showGameCompletedDialog();
          }
        } else {
          // Not a match, flip cards back after a short delay
          _lockBoard = true;
          _flippedBackTimer = Timer(const Duration(milliseconds: 700), () {
            setState(() {
              if (_cardControllers[_previousIndex].state?.isFront != true) {
                _cardControllers[_previousIndex].toggleCard();
              }
              if (_cardControllers[index].state?.isFront != true) {
                _cardControllers[index].toggleCard();
              }
              _previousIndex = -1;
              _lockBoard = false;
            });
          });
        }
      } else {
        // No previous card flipped, store the current card index
        _previousIndex = index;
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('遊戲結束'),
          content: const Text('時間到了！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('再玩一次'),
            ),
          ],
        );
      },
    );
  }

  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('恭喜！'),
          content: const Text('你成功找到所有的配對！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('再玩一次'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    _previousIndex = -1;
    _lockBoard = false;
    _pairsFound = 0;
    _flippedBackTimer?.cancel();
    _gameTimer?.cancel();
    _gameTimer = null;
    _gameDuration = _gameTimeLimit;
    for (var i = 0; i < _cardItems.length; i++) {
      if (_cardControllers[i].state?.isFront == false) {
        _cardControllers[i].toggleCard();
      }
    }
    _cardItems.shuffle();
    setState(() {});
  }

  _renderContent(context, int index,
      {required FlipCardController controller, required String text}) {
    return GestureDetector(
      onTap: () {
        _onCardTap(index);
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: FlipCard(
          controller: controller,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          speed: 300,
          flipOnTouch: false,
          front: Card(
            elevation: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFcccccc),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Image.asset("assets/go.png"),
                  ),
                ],
              ),
            ),
          ),
          back: Card(
            elevation: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF00aed8),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AutoSizeText(text,
                      style: const TextStyle(fontSize: 25, color: Colors.white), maxLines: 2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golang mini Game'),
        actions: [
          IconButton(
              onPressed: () {
                resetGame();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
              child: Text('計時器：${_printDuration(_gameDuration)}',
                  style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: _cardItems.length,
                      itemBuilder: (context, index) {
                        return _renderContent(context, index,
                            controller: _cardControllers[index],
                            text: _cardItems[index].content);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
