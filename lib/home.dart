import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? file;
  late PhotoViewControllerBase<PhotoViewControllerValue> controller;

  bool showButtons = false;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => showButtons = true),
      onExit: (event) => setState(() => showButtons = false),
      child: Scaffold(
        body: Listener(
          onPointerSignal: (event) {
            if (controller.scale == null || event is! PointerScrollEvent) {
              return;
            }

            _zoom(event.scrollDelta.dy < 0);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: file == null
                      ? const SizedBox.shrink()
                      : PhotoView(
                          imageProvider: FileImage(File(file!.path)),
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 10,
                          initialScale: PhotoViewComputedScale.contained * 0.5,
                          controller: controller,
                        ),
                ),
              ),
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: YaruIconButton(
                          onPressed: () => _zoom(false),
                          icon: Center(
                            child: Icon(
                              YaruIcons.minus,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          'Scale: ${controller.scale?.toStringAsFixed(2) ?? '0.5'}'),
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: YaruIconButton(
                        onPressed: () => _zoom(true),
                        icon: Center(
                          child: Icon(
                            YaruIcons.plus,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        appBar: YaruWindowTitleBar(
          style: showButtons
              ? YaruTitleBarStyle.normal
              : YaruTitleBarStyle.undecorated,
          // foregroundColor: showButtons ? null : Colors.transparent,
          titleSpacing: 0,
          leading: Center(
            child: SizedBox(
              height: kYaruTitleBarItemHeight,
              width: kYaruTitleBarItemHeight,
              child: YaruIconButton(
                onPressed: () async {
                  const XTypeGroup typeGroup = XTypeGroup(
                    label: 'images',
                    extensions: <String>['jpg', 'png'],
                  );
                  final newFile = await openFile(
                      acceptedTypeGroups: <XTypeGroup>[typeGroup]);

                  setState(() {
                    if (newFile != null) {
                      file = newFile;
                    }
                  });
                },
                icon: const Icon(
                  YaruIcons.image,
                  size: 20,
                ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          border: BorderSide.none,
          title: Text(file?.path ?? 'Imaginator'),
        ),
      ),
    );
  }

  void _zoom(bool zoomIn) {
    if (zoomIn) {
      setState(() {
        controller.scale = controller.scale! + 0.1;
      });
    } else {
      setState(() {
        controller.scale = controller.scale! - 0.1;
      });
    }
  }
}
