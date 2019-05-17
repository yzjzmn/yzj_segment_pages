import 'package:flutter/material.dart';
import 'dart:ui';
// block
typedef ValueChanged<T, M> = void Function(T value, M valueM);

/**
 * segmentControl
 * 注意 tabs和pages要对应
 */
class YZJSegmentControl extends StatefulWidget {

	final double segmentHeight;
	final double segmentWidth;

	final double pagesHeight;
	final double pagesWidth;

	final List<String> tabs;
	final List<Widget> pages;
	
  final ValueChanged<int, String> selected;
	final Color normalTitleColor;
	final Color activeTitleColor;
  final double normalTitleFontsize;
	final double activeTitleFontsize;
  
  final Color indicatorColor;
	final double indicatorWeight;
  final TabBarIndicatorSize indicatorSize;
	
	final bool selectNone;
	
	YZJSegmentControl({
		@required this.tabs,
    @required this.pages,
		@required this.selected,

		this.segmentHeight = 44.0,
		this.segmentWidth = double.infinity,

    this.pagesHeight = 0.0,
    this.pagesWidth  = double.infinity,

		this.normalTitleColor = Colors.black,
		this.activeTitleColor = Colors.blue,
    this.normalTitleFontsize = 16.0,
    this.activeTitleFontsize = 18.0,

    this.indicatorColor   = Colors.blue,
    this.indicatorWeight = 2.0,
    this.indicatorSize = TabBarIndicatorSize.label,

		this.selectNone = false,
	});
		
	@override
	_YZJSegmentControlState createState() => _YZJSegmentControlState();
}

class _YZJSegmentControlState extends State<YZJSegmentControl> with SingleTickerProviderStateMixin {
	
  TextStyle _normalTitleStyle;
	TextStyle _activeTitleStyle;

  // 上方title的标题栏
  TabController _tabController;
  // 下方承载内容的pages
  final PageController _pageController = PageController();
	
	@override
	void initState() {
		super.initState();
    _normalTitleStyle = TextStyle(fontSize: widget.normalTitleFontsize, color: widget.normalTitleColor);
    _activeTitleStyle = TextStyle(fontSize: widget.activeTitleFontsize, color: widget.activeTitleColor);
    
		_tabController = TabController(length: widget.tabs.length, vsync: this);
		_tabController.addListener(() {
			if (_tabController.indexIsChanging) {
				setState(() {});
        _pageController.jumpTo(MediaQuery.of(context).size.width * _tabController.index);
				widget.selected(_tabController.index, widget.tabs[_tabController.index]);
			}
		});
	}
	
	@override
	Widget build(BuildContext context) {
    // 获取全屏size
    final screenSize = MediaQuery.of(context).size;
    // 顶部bar距离
    final double sStaticBarHeight = MediaQueryData.fromWindow(window).padding.top;
    // 底部bottom距离
    final double sStaticBottomHeight = MediaQueryData.fromWindow(window).padding.bottom;
    // pages显示内容高度  kToolbarHeight:系统导航栏高度
    final double contentHeight = screenSize.height-sStaticBarHeight-sStaticBottomHeight-kToolbarHeight-widget.segmentHeight;
    // 最终的 pagesHeight    
    final pagesHeight = (widget.pagesHeight <= 0 || widget.pagesHeight > contentHeight)?contentHeight:widget.pagesHeight;

		final pageSize = Size(screenSize.width, pagesHeight);

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            segmentTitle(),
            pagesContent(pageSize),
          ],
        ),
      ),
    );
	}

  SizedBox segmentTitle() {
    return SizedBox(
			height: widget.segmentHeight,
			width: widget.segmentWidth,
			child: TabBar(
				controller: _tabController,
				tabs: widget.tabs.map((f) {
					var idx = widget.tabs.indexOf(f);
					return Tab(
						child:new Container(
              padding: EdgeInsets.all(0.0),
              child: Text(
                f, 
                style: 
                (idx == _tabController.index && !widget.selectNone) ? _activeTitleStyle: _normalTitleStyle)
                ) 
					);
				}).toList(),
				isScrollable: false,
				indicatorColor: widget.indicatorColor,
        indicatorWeight: widget.indicatorWeight,
        indicatorSize: widget.indicatorSize,//指示器宽度样式
				labelPadding: EdgeInsets.zero,
			),
		);
  }

  ConstrainedBox pagesContent (Size screenSize) {
    return new ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenSize.width, maxHeight: screenSize.height, minWidth: screenSize.width, minHeight: screenSize.height),
      child: new PageView(
        controller: _pageController,
        children: widget.pages,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        	widget.selected(_tabController.index, widget.tabs[_tabController.index]);
        },
      ),
    );
  }
}
