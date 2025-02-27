import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabviewer_return_to_top/utils.dart';

import 'my_box.dart';

class MyTab extends StatefulWidget {
  final int index;
  final bool isActive;
  final ScrollController controller;

  const MyTab({Key key, this.index, this.isActive = false, this.controller}) : super(key: key);
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'my tab $index $isActive';
  }

  @override
  _MyTabState createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  int childrenCount = 2;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    childrenCount += widget.index;
  }

  bool onNotification(ScrollNotification notification) {
    print('on scroll');

    if (widget.isActive && !loading) {
      if ((notification is OverscrollNotification &&
              notification.overscroll > 0) ||
          (notification is ScrollUpdateNotification &&
              notification.metrics.extentAfter < 200)) {
        load();
      }
    }
    return false;
  }

  Future<void> load() async {
    print('${widget.index} on load');
    loading = true;
    pfCb(() {
      if (mounted) setState(() {});
    });
    await Future.delayed(Duration(seconds: 3));

    childrenCount += 2;
    pfCb(() {
      if (mounted)
        setState(() {
          loading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: ListView.builder(
        // automaticKeepAlive stopped keeping extents with primary
        // primary: widget.isActive,
        physics: AlwaysScrollableScrollPhysics(),
        controller: widget.controller,

        itemCount: childrenCount + (loading ? 1 : 0),
        itemBuilder: (context, index) => index == childrenCount
            ? Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(14),
                height: 64,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : MyBox(index: index),
      ),
    );
  }
}
