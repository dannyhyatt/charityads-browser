import 'package:flutter/material.dart';

class Tabs with ChangeNotifier {

  static List<BrowserTab> _tabs = List<BrowserTab>();

  void addTab(BrowserTab browserTab) {
    _tabs.insert(_tabs.length, browserTab);
    notifyListeners();
  }

  List<BrowserTab> getTabs() => _tabs;

  int getNumTabs() => _tabs.length;

  BrowserTab getTabByTimestamp(int x) {
    for (var tab in _tabs) {
      if (tab.created == x) {
        return tab;
      }
    }
    return null;
  }

  void update() {
    notifyListeners();
  }

}

class BrowserTab {

  List<TabInstance> _history = List<TabInstance>();
  final bool private;
  int created;
  int historyIndex = 0;

  BrowserTab({this.private = false}) {
    created = DateTime.now().millisecondsSinceEpoch;
  }

  TabInstance getCurrentTab() {
    if (_history.length == 0) {
      _history.add(TabInstance(
        url: 'newtab',
        title: 'New Tab',
        timestamp: created
      ));
    }
    return _history[0];
  }

  void addTabInstance(TabInstance t) {
    _history.add(t);
    historyIndex++;
  }

}

class TabInstance {

  String url = '';
  String title = 'Tab';
  int timestamp;
  int tabId;

  TabInstance({
    @required
    this.url,
    this.title,
    this.timestamp,
    this.tabId
  }) {
    // async add to history in sqlite todo
  }

}