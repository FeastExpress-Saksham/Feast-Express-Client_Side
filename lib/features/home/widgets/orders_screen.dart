import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:munchmate/common/colors.dart';
import 'package:munchmate/common/constants.dart';
import 'package:munchmate/common/utils/utils.dart';
import 'package:munchmate/features/home/screens/maps_screen.dart';
import 'package:munchmate/features/home/services/wallet_backend.dart';
import 'package:munchmate/features/home/widgets/order_card.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../../common/themes.dart';
import '../../../provider/localUserProvider.dart';
import '../../../provider/orderProvider.dart';
import '../../../provider/theme_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

var httpClient = Client();

class _OrdersScreenState extends State<OrdersScreen> {
  Client? httpClient;
  Web3Client? ethClient;
  @override
  void initState() {
    // TODO: implement initState
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.7,
      width: width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
              "My Order",
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.05,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.44,
                  child:
                      (Provider.of<OrderProvider>(context).order.items.isEmpty)
                          ? Lottie.asset(
                              "assets/jsons/rain.json",
                              width: width * 0.8,
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: Provider.of<OrderProvider>(context)
                                  .order
                                  .items
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return OrderCard(
                                  index: index,
                                );
                              },
                            ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        var location = await getCurrentLocation();
                        print(location[0]);
                      },
                      child: Text("Current Location")),
                ),
                Text(
                  "Total : ₹ ${Provider.of<OrderProvider>(context).order.totalPrice.toString()}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.05,
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            AppThemes.light
                        ? AppColors.black
                        : AppColors.white.withOpacity(0.8),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(primaryColor),
                        ),
                        onPressed: () async {
                          var location = await getCurrentLocation();
                          print(location.runtimeType);
                          print(location[0]);
                          print(location[1]);
                          int i = 0;
                          for (i = 0;
                              i <
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .order
                                      .items
                                      .length;
                              i++) {
                            await cordsend(location);
                          }
                          if (Provider.of<OrderProvider>(context, listen: false)
                              .order
                              .items
                              .isEmpty) {
                            showToast('Select items to order!');
                            return;
                          }
                          Navigator.pop(context);
                          Provider.of<OrderProvider>(context, listen: false)
                              .placeOrder(
                                  Provider.of<LocalUserProvider>(context,
                                          listen: false)
                                      .localUser
                                      .id,
                                  context);
                          showToast('Ordered!');
                          Provider.of<LocalUserProvider>(context, listen: false)
                              .getLastOrders(context);
                          sendToken(owner_private_key, BigInt.from(int.parse(
                                                      "30") *
                                                  100), ethClient!);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapScreen()));
                        },
                        child: Text(
                          'Pay',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCurrentLocation() async {
    Location location = Location();

    LocationData _locationData;

    _locationData = await location.getLocation();

    // setState(() {
    //   //_center = LatLng(_locationData.latitude, _locationData.longitude);
    //   controller.move(
    //       LatLng(_locationData.latitude!, _locationData.longitude!), 13.0);
    // });

    return [_locationData.latitude!, _locationData.longitude!];
  }

  Future<String> cordsend(List<double> loc) async {
    int i = 0;
    try {
      Response response = await post(
        Uri.parse("https://e-commerce-marketplace-pfdj.onrender.com/api/array"),
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode(
            // {
            //   "coordinates": [
            //     {
            //       "lat": loc[0],
            //       "lon": loc[1],
            //       "item": "Location A"
            //     },
            //   ]
            // },
            {
              "coordinates": [
                {
                  "lat": loc[0],
                  "lon": loc[1],
                  "foodOrders": [
                    {
                      "itemName":
                          Provider.of<OrderProvider>(context, listen: false)
                              .order
                              .items[i]
                              .toString(),
                      "quantity": 1
                    }
                  ]
                }
                // Additional coordinates with food orders
              ]
            }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
        return "Success";
      } else {
        print('failed');
        print(response.statusCode);
        return "Fail";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
