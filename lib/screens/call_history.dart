import 'package:flutter/material.dart';
import 'package:voice_dial/size_helper.dart';
import 'package:call_log/call_log.dart';
import 'package:call_number/call_number.dart';

class CallHistory extends StatefulWidget {
  @override
  _CallHistoryState createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  Iterable<CallLogEntry> _callLogEntries = [];

  _initCall(String number) async {
    await new CallNumber().callNumber(number);
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  Future<void> getHistory() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    var now = DateTime.now();
    int from = now.subtract(Duration(days: 7)).millisecondsSinceEpoch;
    int to = now.millisecondsSinceEpoch;
    var result = await CallLog.query(
      dateFrom: from,
      dateTo: to,
    );
    setState(() {
      _callLogEntries = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mono = TextStyle(fontFamily: 'monospace');
    var children = <Widget>[];
    _callLogEntries.forEach((entry) {
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(entry.timestamp).toString();
      children.add(
        Column(
          children: <Widget>[
            Container(
              width: displayWidth(context),
              height: displayHeight(context) * 0.1,
              child: FlatButton(
                onPressed: () {
                  _initCall(entry.formattedNumber);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: displayWidth(context) * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ('${entry.name}' == 'null')
                            Text(
                              'unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: displayWidth(context) * 0.005,
                                fontSize: displayHeight(context) * 0.025,
                              ),
                            )
                          else
                            Text(
                              '${entry.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: displayWidth(context) * 0.005,
                                fontSize: displayHeight(context) * 0.025,
                              ),
                            ),
                          Text(
                            '${entry.cachedMatchedNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Start time:',
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'Date: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${dateTime.substring(10, 16)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${dateTime.substring(8, 10)}-${dateTime.substring(5, 7)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    });

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// Text('F. NUMBER  : ${entry.formattedNumber}', style: mono),
// Text('C.M. NUMBER: ${entry.cachedMatchedNumber}', style: mono),
// Text('NUMBER     : ${entry.number}', style: mono),
// Text('NAME       : ${entry.name}', style: mono),
// Text('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp)}',
// style: mono),
// Text('DURATION   :  ${entry.duration}', style: mono),
