import 'tabs.dart';
import 'package:flutter/material.dart';

class TabPreviewNotifier with ChangeNotifier {

  Tabs tabs;

  TabPreviewNotifier(this.tabs);

  void update() {
    notifyListeners();
  }

}