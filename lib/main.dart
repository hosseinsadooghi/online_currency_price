import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_currency_price/Models/Currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fa'), // farsi
        ],
        theme: ThemeData(
            fontFamily: 'dana',
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              bodyLarge: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
              displayMedium: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              bodyMedium: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
              displaySmall: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w700),
              headlineMedium: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w700),
            )),
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext context) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";

    var value = await http.get(Uri.parse(url));

    //next line is used for debuging and has nothing to do with the main code
    developer.log(value.body,
        name: "getResponse", error: convert.jsonDecode(value.body));

    if (value.statusCode == 200 && currency.isEmpty) {
      _showSnackBar(context, "بروزرسانی اطلاعات با موفقیت انجام شد");
      List jsonList = convert.jsonDecode(value.body);
      if (jsonList.isNotEmpty) {
        for (int i = 0; i < jsonList.length; i++) {
          setState(() {
            currency.add(Currency(
                id: jsonList[i]["id"],
                title: jsonList[i]["title"],
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"]));
          });
        }
      }
    }

    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //to run this whole function only one time we should call it in initstate
    getResponse(context);
    developer.log("initState", name: "wlifeCycle");
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    developer.log("didUpdateWidget", name: "wlifeCycle");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    developer.log("didChangeDependencies", name: "wlifeCycle");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 28, 0),
              child: Image.asset("assets/images/money_bag.png"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text("قیمت به روز ارز",
                  style: Theme.of(context).textTheme.displayLarge),
            ),
            // Expanded(
            //     child: Align(
            //         alignment: Alignment.centerLeft,
            //         child: Image.asset("assets/images/menu.png"))),
            Expanded(
              child: const SizedBox(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/752675.png"),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("نرخ ارز آزاد چیست؟",
                        style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 130, 130, 130),
                        borderRadius: BorderRadius.all(Radius.circular(1000))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "نام آزاد ارز",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          "قیمت",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          "تغییر",
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 345,
                  child: listFutureBuilder(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 232, 232),
                        borderRadius: BorderRadius.circular(1000)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          child: TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color.fromARGB(255, 202, 193, 255)),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000)
                                          )
                                      )
                              ),
                              onPressed: () {
                                currency.clear();
                                listFutureBuilder(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh_bold,
                                color: Colors.black,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  "بروزرسانی",
                                  style: Theme.of(context).textTheme.displayLarge,
                                ),
                              )
                          ),
                        ),
                        Text(
                          'آخرین بروزرسانی ${_getTime()}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          width: 0,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: MyItem(position, currency),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;

  MyItem(
    this.position,
    this.currency, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(blurRadius: 1.0, color: Colors.grey)
      ], 
      color: Colors.white, borderRadius: BorderRadius.circular(1000)),
      child: Stack(
          alignment: Alignment.centerLeft,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Positioned(
              right: 27,
              child: Text(
                currency[position].title!,
                style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Positioned(
              left: 125,
              child: Text(
                changeNumbersToFarci(currency[position].price.toString()),
                style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Positioned(
              left: 27,
              child: Text(
                changeNumbersToFarci(currency[position].changes.toString()),
                style: currency[position].status == "n"
                    ? Theme.of(context).textTheme.displaySmall
                    : Theme.of(context).textTheme.headlineMedium,
                ),
              ),
          ]
        ),
    );
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.displayLarge,
    ),
    backgroundColor: Colors.green,
  ));
}

String changeNumbersToFarci(String number) {
  const en = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  const fa = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}
