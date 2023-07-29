import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'imaginator.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  runApp(
    const Imaginator(),
  );
}
