// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static m0(duration) => "計時器：${duration}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "app_title" : MessageLookupByLibrary.simpleMessage("Golang 小遊戲"),
    "congratulations" : MessageLookupByLibrary.simpleMessage("恭喜！"),
    "foundAllPairs" : MessageLookupByLibrary.simpleMessage("你成功找到所有的配對！"),
    "gameOver" : MessageLookupByLibrary.simpleMessage("遊戲結束"),
    "gameTitle" : MessageLookupByLibrary.simpleMessage("Golang 小遊戲"),
    "playAgain" : MessageLookupByLibrary.simpleMessage("再玩一次"),
    "timeUp" : MessageLookupByLibrary.simpleMessage("時間到了！"),
    "timer" : m0
  };
}
