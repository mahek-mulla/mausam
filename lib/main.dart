import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:translator/translator.dart';

void main() => runApp(Mausam3());

class Mausam3 extends StatefulWidget {
  @override
  _Mausam3State createState() => _Mausam3State();
}

final url = "https://api.openweathermap.org/data/2.5/weather";
final apiKey =
    "add_your own api key";

class _Mausam3State extends State<Mausam3> {
  GoogleTranslator translator =
      new GoogleTranslator(); //using google translator

  String out;

  bool isLoading = true;
  var weatherData;
  String weather;
  String city;
  String temp;
  String wind;
  String humid;
  String pres;
  String bgImg;
  String iconUrl;
  String desc;
  String hindicity;

  getWeather(lat, lon) async {
    try {
      await http
          .get(url + "?lat=$lat&lon=$lon&units=metric&appid=$apiKey")
          .then((response) => weatherData = jsonDecode(response.body));
      if (weatherData['cod'] == 200) {
        print(weatherData);
        print("\n");
        print(weatherData["weather"][0]["main"]);
        print("\n");
        print(weatherData["name"]);
        print(weatherData['wind']['speed']);
        print(weatherData['main']['humidity']);
        print(weatherData['main']['pressure']);
        print(weatherData["weather"][0]["description"]);
        weather = weatherData['weather'][0]['main'];
        city = weatherData["name"];
        desc = (weatherData["weather"][0]["description"]);
        temp = (weatherData["main"]["temp"]).toString();
        wind = (weatherData['wind']['speed']).toString();
        humid = (weatherData['main']['humidity']).toString();
        pres = (weatherData['main']['pressure']).toString();
        print(weatherData['weather'][0]['main']); //weather[0].main
        setState(() {
          isLoading = false;
        });
      } else {
        print(weatherData['cod']);
      }
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (await Permission.location.request().isGranted) {
        LocationData location = await Location().getLocation();
        getWeather(location.latitude, location.longitude);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void trans() {
    translator.translate(desc, from: "en", to: 'hi') //translating to hi = hindi
        .then((output) {
      setState(() {
        out = output
            .toString(); //placing the translated text to the String to be used
      });
      print(out);
    });
  }

  void citytrans() {
    translator.translate(city, from: "en", to: 'hi') //translating to hi = hindi
        .then((output) {
      setState(() {
        hindicity = output
            .toString(); //placing the translated text to the String to be used
      });
      print(out);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (weather == 'Clear') {
      bgImg = 'assets/sunny.jpg';
    } else if (weather == 'Smoke') {
      bgImg = 'assets/smoke.jpg';
    } else if (weather == 'Rain') {
      bgImg = 'assets/rainy.jpg';
    } else if (weather == 'Clouds') {
      bgImg = 'assets/cloudy.jpeg';
    } else if (weather == 'Haze') {
      bgImg = 'assets/haze.jpg';
    } else if (weather == 'Snow') {
      bgImg = 'assets/snow.jpg';
    }
    if (weather == 'Clear') {
      iconUrl = 'assets/sun.svg';
    } else if (weather == 'Night') {
      iconUrl = 'assets/moon.svg';
    } else if (weather == 'Rain') {
      iconUrl = 'assets/rain.svg';
    } else if (weather == 'Clouds' ||
        weather == 'Smoke' ||
        weather == 'Haze' ||
        weather == 'Snow') {
      iconUrl = 'assets/cloudy.svg';
    } else if (weather == 'Snow') {
      iconUrl = 'assets/snow.svg';
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child:
              /*Stack(
            children: [
              Image.asset(
                bgImg != null ? bgImg : 'null',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),*/
              Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(bgImg),
                    fit: BoxFit.cover)), // added by me
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              hindicity != null
                                  ? hindicity
                                  : 'null', //locationList[index].city,
                              style: GoogleFonts.lato(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              desc != null
                                  ? desc
                                  : 'null', //locationList[index].dateTime,
                              style: GoogleFonts.acme(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  temp != null
                                      ? temp
                                      : 'null', //locationList[index].temparature,

                                  style: GoogleFonts.lato(
                                    fontSize: 75,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "\u00B0C", //locationList[index].temparature,

                                  style: GoogleFonts.lato(
                                    fontSize: 75,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  iconUrl != null ? iconUrl : 'null',
                                  width: 34,
                                  height: 34,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  weather != null ? weather : 'null',
                                  style: GoogleFonts.lato(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              out != null
                                  ? out
                                  : 'null', //locationList[index].dateTime,
                              style: GoogleFonts.lato(
                                fontSize: 70,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Wind',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                wind != null
                                    ? wind
                                    : 'okay', //locationList[index].wind.toString(),
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'km/h',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 70,
                                    color: Colors.white38,
                                  ),
                                  Container(
                                    height: 5,
                                    width: double.parse(
                                        wind), //locationList[index].wind / 2,
                                    color: Colors.greenAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Pressure',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                pres != null
                                    ? pres
                                    : 'null', //locationList[index].rain.toString(),
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Pa',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 70,
                                    color: Colors.white38,
                                  ),
                                  Container(
                                    height: 5,
                                    width: int.parse(pres) /
                                        100, //locationList[index].rain / 2,
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Humidity',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                humid != null
                                    ? humid
                                    : 'null', //locationList[index].humidity.toString(),
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '%',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 5,
                                    width: 70,
                                    color: Colors.white38,
                                  ),
                                  Container(
                                    height: 5,
                                    width: int.parse(humid) /
                                        2, //locationList[index].humidity / 2,
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //],
          //),
        ),
      ),
    );
  }
}

/*
Container(
            child: Center(
              child: isLoading
                  ? Text("Loading......")
                  : TextButton(
                      onPressed: () {
                        getWeather("18.5196", "73.8553");
                      },
                      child: Text(weatherData == null
                          ? "Click me! "
                          : weatherData['weather'][0]['main'].toString()),
                    ),
            ),
          ),*/
