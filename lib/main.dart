import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/SampleApp.dart';

//main函数使用了(=>)符号, 这是Dart中单行函数或方法的简写。
void main() => runApp(new MyApp());

//该应用程序继承了 StatelessWidget，这将会使应用本身也成为一个widget。
// 在Flutter中，大多数东西都是widget，包括对齐(alignment)、填充(padding)和布局(layout)
//Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.
class MyApp extends StatelessWidget {

//  widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己。
  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
    return new MaterialApp(
//      title: 'Welcome to Flutter',
////        Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。
//// widget树可以很复杂。
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter'),
//        ),
////          本示例中的body的widget树中包含了一个Center widget, Center widget又包含一个 Text 子widget。
//// Center widget可以将其子widget树对其到屏幕中心。
//        body: new Center(
////          child: new Text(wordPair.asPascalCase),
//          child: new RandomWords(),
//        ),
//      ),
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
      routes: <String,WidgetBuilder>{
        '/a': (BuildContext context) => new SampleApp(),
      },
    );
  }
}

//Stateful widgets 持有的状态可能在widget生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:
//
//一个 StatefulWidget类。
//一个 State类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
//  向RandomWordsState类中添加一个_suggestions列表以保存建议的单词对。
// 该变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的。
  final _suggestions = <WordPair>[];

//  添加一个 _saved Set(集合) 到RandomWordsState。这个集合存储用户喜欢（收藏）的单词对。
// 在这里，Set比List更合适，因为Set中不允许重复的值。
  final _saved = new Set<WordPair>();

//  另外，添加一个biggerFont变量来增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    final wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
//          在RandomWordsState的build方法中为AppBar添加一个列表图标。
// 当用户点击列表图标时，包含收藏夹的新路由页面入栈显示。
//
//      提示: 某些widget属性需要单个widget（child），而其它一些属性，如action，需要一组widgets(children），用方括号[]表示。
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
          new IconButton(icon: new Icon(Icons.layers), onPressed: _lifeCycle),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();

          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {
//    _buildRow 方法中添加 alreadySaved来检查确保单词对还没有添加到收藏夹中。
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
//        同时在 _buildRow()中， 添加一个心形 ❤️ 图标到 ListTiles以启用收藏功能。
// 接下来，你就可以给心形 ❤️ 图标添加交互能力了。
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
//        在 _buildRow中让心形❤️图标变得可以点击。
// 如果单词条目已经添加到收藏夹中， 再次点击它将其从收藏夹中删除。
// 当心形❤️图标被点击时，函数调用setState()通知框架状态已经改变。
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
//    当用户点击导航栏中的列表图标时，建立一个路由并将其推入到导航管理器栈中。此操作会切换页面以显示新路由。
//
//    新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数。
//
//    添加Navigator.push调用，这会使路由入栈（以后路由入栈均指推入到导航管理器的栈）
    Navigator.of(context).push(
//    添加MaterialPageRoute及其builder。
// 现在，添加生成ListTile行的代码。
// ListTile的divideTiles()方法在每个ListTile之间添加1像素的分割线。
// 该 divided 变量持有最终的列表项。
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
//          builder返回一个Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。
// 新路由的body由包含ListTiles行的ListView组成; 每行之间通过一个分隔线分隔。
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  void _lifeCycle() {
    Navigator.of(context).pushNamed('/a');
  }
}

