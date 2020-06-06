import 'package:charityadsbrowser/notifiers.dart';
import 'package:provider/provider.dart';

import 'browser_tab_view.dart';
import 'tabs.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class TabsView extends StatefulWidget {
  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {

            },
          )
        ],
      ),
      body: GridView.count(
        // crossAxisCount is the number of columns
        crossAxisCount: 2,
        // This creates two columns with two items in each column
        children: List.generate(Provider.of<TabPreviewNotifier>(context, listen: false).tabs.getNumTabs(), (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 3,
              child: _TabPreview(Provider.of<TabPreviewNotifier>(context, listen: false).tabs.getTabs()[index])
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class _TabPreview extends StatefulWidget {

  final BrowserTab browserTab;
  _TabPreview(this.browserTab);

  @override
  __TabPreviewState createState() => __TabPreviewState();
}

class __TabPreviewState extends State<_TabPreview> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => BrowserTabView(widget.browserTab)));
        },
        child: AspectRatio(
          aspectRatio: 4/3,
          child: Column(
            children: [
              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.2,
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 0.7,
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
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            debugPrint('close btn pressed for ${widget.browserTab.getCurrentTab().title}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
