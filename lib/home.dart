import 'package:flutter/material.dart';
import 'package:residemenu/residemenu.dart';
import 'detail.dart';
import 'package:share/share.dart';
import 'full_image.dart';
import 'textStyle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:flutter/gestures.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

//This class helps to create links, that we are using in about dialog.
class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                urlLauncher.launch(url);
              });
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  MenuController _menuController;
  var data;

  /// to build a reside menu drawer build by library
  Widget buildItem(String msg, VoidCallback method) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        child: ResideMenuItem(
          title: msg,
          icon: const Icon(Icons.home, color: Colors.grey),
          right: const Icon(Icons.arrow_forward, color: Colors.grey),
        ),
        onTap: () => method,
      ),
    );
  }

  _sharer() {
    Share.share(" PLACE-PREP - Makes you Placement Ready.\n" +
        "The app that will make you an amazing candidate for any job.\n"
            "Are you ready?\n"
            "Download it now\n"
            "https://bit.ly/place_prep");
  }

  _launchgmail() async {
    const url =
        'mailto:varungattani200319@gmail.com?subject=Feedback&body=Feedback for PlacePrep';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _menuController = new MenuController(vsync: this);
  }

  ///shows the about dialog.
  showAbout(BuildContext context) {
    final TextStyle linkStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue);
    final TextStyle bodyStyle =
        new TextStyle(fontSize: 15.0, color: Colors.black);

    return showAboutDialog(
        context: context,
        applicationIcon: Center(
          child: Image(
            height: 150.0,
            width: 200.0,
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/images/download.jpg"),
          ),
        ),
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: new RichText(
                  textAlign: TextAlign.start,
                  text: new TextSpan(children: <TextSpan>[
                    new TextSpan(
                        style: bodyStyle,
                        text:
                            ' If you have any business/organisation/ideas and you want us to improve this app ,then  feel free to contact . '
                            "\n\n"),
                    new TextSpan(
                      style: bodyStyle,
                      text: 'for any Queries/Suggestions:' + "\n\n",
                    ),
                    new _LinkTextSpan(
                        style: linkStyle,
                        text: 'Send an E-mail' + "\n\n",
                        url:
                            'mailto:varungattani200319@gmail.com?subject=PlacePrep&body=Suggestions'),
                  ]))),
        ]);
  }

  ///Lis-t of interview questions.
  Widget getListItems(Color color, IconData icon, String title) {
    return GestureDetector(
        key: title == 'Behavioural Based' ? Key('item') : null,
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: color),
          height: 300.0,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 100.0,
                color: Colors.white,
              ),
              Text(
                title,
                style: Style.headerstyle,
              )
            ],
          )),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Detail(
                    title: title,
                  )));
        });
  }

  ///creating a carousel using carousel pro library.
  final myCraousal = Carousel(
    dotSize: 5.0,
    dotIncreaseSize: 2.0,
    borderRadius: true,
    radius: Radius.circular(10.0),
    animationCurve: Curves.easeInOut,
    animationDuration: Duration(seconds: 2),
    images: [
      AssetImage('assets/images/card1.png'),
      AssetImage('assets/images/card3.png'),
      AssetImage('assets/images/card4.png'),
      AssetImage('assets/images/card2.png'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //to use reside menu library we have to return a residemenu scafford.
    return new ResideMenu.scaffold(
      //direction: ScrollDirection.LEFT,
      decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover)),
      controller: _menuController,
      leftScaffold: new MenuScaffold(
        header: new ConstrainedBox(
          constraints: new BoxConstraints(maxHeight: 80.0, maxWidth: 100.0),
          child: GestureDetector(
            child: new CircleAvatar(
              backgroundImage: new AssetImage('assets/images/capture.png'),
              radius: 30.0,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullImage(),
                ),
              );
            },
          ),
        ),
        children: <Widget>[
          ///I have to make these drawer list widgets manually cause it is containing different methods.
//           added Changes
          new Material(
            color: Colors.transparent,
            child: new InkWell(
              child: FittedBox(
                child: ResideMenuItem(
                  title: 'Share the App',
                  titleStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      backgroundColor: Colors.transparent),
                  icon: const Icon(Icons.share, color: Colors.black),
                ),
              ),
              onTap: () => _sharer(),
            ),
          ),
          new Material(
            color: Colors.transparent,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'Suggestions',
                titleStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    backgroundColor: Colors.transparent),
                icon: const Icon(Icons.bug_report, color: Colors.black),
              ),
              onTap: () => _launchgmail(),
            ),
          ),
        ],
      ),
      child: new Scaffold(
        appBar: new AppBar(
          elevation: 10.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: new GestureDetector(
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onTap: () {
              _menuController.openMenu(true);
            },
          ),
          title: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/students-cap.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    new Text(
                      'Place Prep',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    Text(
                      'Lead the way',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.black,
                  size: 20.0,
                ),
                onPressed: () => showAbout(context))
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              key: Key('banner'),
              padding: EdgeInsets.only(bottom: 5.0),
              height: height / 2.5,
              child: myCraousal,
            ),
            getListItems(Color(0xFFF1B136), Icons.person, 'Behavioural Based'),
            getListItems(Color(0xFF885F7F), Icons.wc, 'Communications Based'),
            getListItems(Color(0xFF13B0A5), Icons.call_split, 'Opinion Based'),
            getListItems(
                Color(0xFFD0C490), Icons.assessment, 'Performance Based'),
            getListItems(Color(0xFFEF6363), Icons.help_outline, 'Brainteasers'),
          ],
        ),
      ),
    );
  }
}
