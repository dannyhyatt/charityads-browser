import 'package:charityadsbrowser/notifiers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import 'tabs.dart';
import 'package:flutter/material.dart';

class BrowserTabView extends StatefulWidget {

  final BrowserTab browserTab;
  BrowserTabView(this.browserTab);

  @override
  _BrowserTabViewState createState() => _BrowserTabViewState();
}

class _BrowserTabViewState extends State<BrowserTabView> {

  InAppWebViewController _controller;

  double height = 3000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Consumer<TabPreviewNotifier>(
                builder: (ctx, change, title) {
                  // todo double check should it be change.tabs?
                  debugPrint('got tittitti');
                  return Row(
                    children: [
                      Expanded(
                        child: Consumer<TabPreviewNotifier>(
                          builder: (ctx, change, title) {
                            // todo double check should it be change.tabs?
                            debugPrint('got tittitti');
                            return Text(change.tabs
                                .getTabByTimestamp(
                                widget.browserTab.created)
                                .getCurrentTab()
                                .title ?? change.tabs
                                .getTabByTimestamp(
                                widget.browserTab.created)
                                .getCurrentTab()
                                .url ?? 'Empty Tab',
                                style: TextStyle(color: Colors.white));
                          }
                        )
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {

                        },
                      )
                    ],
                  );
                }
            ),
            floating: true,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.flip_to_front, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
                  child:
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: InAppWebView(
                        gestureRecognizers: [
                          Factory(() => _PlatformViewVerticalGestureRecognizer()),
                        ].toSet(),
                        initialUrl: widget.browserTab.getCurrentTab().url,
                        onWebViewCreated: (c) {
                          _controller = c;
                        },
                        onLoadStop: (c, _) async {
                          Provider.of<TabPreviewNotifier>(context, listen: false).tabs.getTabByTimestamp(widget.browserTab.created).getCurrentTab().title = await _controller.getTitle();
                          Provider.of<TabPreviewNotifier>(context, listen: false).update();
                          debugPrint('yuh? ${widget.browserTab.getCurrentTab().title}');
                        }
                      ),
                    ),
                ),
              ]
            ),
    );
  }
}

class _PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  _PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}