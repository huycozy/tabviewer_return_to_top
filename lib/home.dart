import 'package:flutter/material.dart';
import 'package:tabviewer_return_to_top/utils.dart';

import 'my_tab.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

const int _tabsLength = 4;

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController ctrl;
  int activeTab;
  GlobalKey key;
  List<ScrollController> controllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  @override
  void initState() {
    super.initState();
    activeTab = 0;
    ctrl = TabController(
      vsync: this,
      length: _tabsLength,
      initialIndex: activeTab,
    );
    ctrl.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!ctrl.indexIsChanging && activeTab != ctrl.index) {
      activeTab = ctrl.index;
      pfCb(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    ctrl.removeListener(_onTabChanged);
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TabView return-to-top'),
        bottom: TabBar(
          controller: ctrl,
          tabs: [
            for (int i = 0; i < _tabsLength; i++)
              Padding(
                padding: EdgeInsets.all(16),
                child: Text('tab $i'),
              ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.timer_outlined),
                onPressed: () {
                  // PrimaryScrollController.of(context).animateTo(0,
                  //     duration: Duration(seconds: 1), curve: Curves.easeInOut);
                  controllers[activeTab].animateTo(0,
                      duration: Duration(seconds: 1), curve: Curves.easeInOut);
                },
              );
            },
          )
        ],
      ),
      body: TabBarView(
        controller: ctrl,
        children: <Widget>[
          for (int i = 0; i < _tabsLength; i++)
            MyTab(
              key: ValueKey<int>(i),
              index: i,
              isActive: activeTab == i,
              controller: controllers[i],
            )
        ],
      ),
    );
  }
}
