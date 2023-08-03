import 'package:flutter_golang_flip_game/flip_card_game_screen.dart';

class Constants {
  static final List<CardContent> cardItems = <CardContent>[
    CardContent(1, "var"),
    CardContent(1, "a := 123"),
    CardContent(2, "slice"),
    CardContent(2, "var a []int"),
    CardContent(3, "for loop"),
    CardContent(3, "for _, v := range arr {}"),
    CardContent(4, "null"),
    CardContent(4, "nil"),
    CardContent(5, "function"),
    CardContent(5, "func Test()"),
    CardContent(6, "error"),
    CardContent(6, "errors.New('err msg')"),
    CardContent(7, "struct"),
    CardContent(7, "type a struct{}"),
    CardContent(8, "interface"),
    CardContent(8, "type a interface{}"),
  ];
}
