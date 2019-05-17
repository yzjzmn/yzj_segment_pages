# yzj_segment_pages

使用tab和pageView完成一个segmentPages,使用起来很简单

使用方法:
YZJSegmentControl(
  segmentHeight: 50.0,//分段控制器的高度
  normalTitleFontsize: 15.0,//正常显示的字体font
  activeTitleFontsize: 15.0,//选中状态下的font

  tabs: ["应用消息", "版本更新"],//分段控制器的文本
  pages: [new MessageApplicationPage(),
          new MessageVersionPage()],//对应的page
  selected: (index, title) {
	  setState(() {            
    });
   }// 选中分段控制的回调,外部没特殊操作可不去实现
  )

// 还可以自定义字体颜色 指示器的颜色等

