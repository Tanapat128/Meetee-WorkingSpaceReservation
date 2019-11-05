import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/countDownPanel.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/activationPage.dart';
import 'package:meetee_mobile/pages/bookingPage.dart';
import 'package:meetee_mobile/pages/historyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';

import 'package:meetee_mobile/pages/selectFacility.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final upComingBookingJson;

  HomePage({
    Key key,
    this.userName,
    this.upComingBookingJson,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String upComingUrl = 'http://18.139.12.132:9000/user/history/upcoming';
  final String countDownUrl = 'http://18.139.12.132:9000/activate/initial';
  final String historyUrl = 'http://18.139.12.132:9000/user/history';
  Map<String, String> headers = {"Content-type": "application/json"};
  String body = '{'
      '"userId": 1'
      '}';

  Timer _timer;
  int _start;

  @override
  void initState() {
    print('init: ${widget.upComingBookingJson}');
//    countDownToUnlock();
    _start = DateTime.parse(widget.upComingBookingJson[0]["start_time"])
        .difference(
          DateTime.now(),
        )
        .inSeconds;
    _start = 7200;
//    _start = 172850;
    print('seconds: $_start');
    getHistoryByUserId();

    super.initState();
  }

  List historiesList;

  Future<dynamic> getHistoryByUserId() async {
    final response = await http.post(
      historyUrl,
      body: {
        "userId": '1',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
//        historiesList = HistoriesList.fromJson(jsonData);
        historiesList = (json.decode(response.body));
      });

      print(historiesList[0]["catename"]);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  _buildUpComingBookingCard(int index) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        color: Colors.black,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 5 / 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${DateFormat("d MMM").format(
                      DateTime.parse(
                          widget.upComingBookingJson[0]["start_time"]),
                    )}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    'Start: ${DateFormat("HH:00").format(
                      DateTime.parse(
                          widget.upComingBookingJson[0]["start_time"]),
                    )}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Bar Table',
                        style: TextStyle(
                          color: Colors.yellow[600],
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        ' x 2',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Meeting Room S',
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        ' x 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHistoryList(int index) {
    return ListTile(
      title: Text('dfgdfgd'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) {
//                return SelectFacilityType();
//              },
//            ),
//          );
//        },
//        child: Icon(
//          Icons.add,
//        ),
//      ),
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              centerTitle: false,
              floating: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('userName');
                    prefs.remove('passWord');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  },
                ),
              ],
              title: Text(
                '${DateFormat("EEEE d MMMM").format(DateTime.now())}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  0.0,
                  0.0,
                  16.0,
                ),
                child: Text(
                  'Welcome, ${widget.userName}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  0.0,
                  16.0,
                  0.0,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        'images/single_chair.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          20.0,
                          0.0,
                          0.0,
                          18.0,
                        ),
                        child: Text(
                          'Most\nBooking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[600],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    facilityTypeList[0].imagePath,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 24,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Single Chair',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${facilityTypeList[0].typeName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 40.0,
                              width: 80.0,
                              child: RaisedButton(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                color: Colors.white,
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BookingPage(
                                          facilityType: facilityTypeList[0],
                                          index: 0,
                                          subType: 0 == 0 ? 'Seat' : 'Room',
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
//                  Container(
//                    margin: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 8.0),
//                    width: double.infinity,
//                    height: 1.0,
//                    color: Colors.black38,
//                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 40.0, 0.0, 8.0),
                    child: Text(
                      'Upcoming bookings',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
//                letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 3.0,
                    margin: EdgeInsets.fromLTRB(
                      16.0,
                      4.0,
                      MediaQuery.of(context).size.width - 64.0,
                      4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.upComingBookingJson == null
                      ? 0
                      : widget.upComingBookingJson.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildUpComingBookingCard(index);
                  },
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
//                  Container(
//                    margin: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 8.0),
//                    width: double.infinity,
//                    height: 1.0,
//                    color: Colors.black38,
//                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                    child: Text(
                      'History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
//                letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 3.0,
                    margin: EdgeInsets.fromLTRB(
                      16.0,
                      4.0,
                      MediaQuery.of(context).size.width - 64.0,
                      4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // To convert this infinite list to a list with three items,
                  // uncomment the following line:
                  // if (index > 3) return null;
                  return _buildHistoryList(index);
                },
                // Or, uncomment the following line:
                childCount: historiesList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
