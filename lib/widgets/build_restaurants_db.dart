import 'package:flutter/material.dart';
import 'package:flutter_food_delivery_ui/data/data.dart';
import 'package:flutter_food_delivery_ui/data/firebase_api.dart';
import 'package:flutter_food_delivery_ui/models/firebase_file.dart';
import 'package:flutter_food_delivery_ui/models/restaurant.dart';
import 'package:flutter_food_delivery_ui/screens/restaurant_screen.dart';
import 'package:flutter_food_delivery_ui/widgets/rating_stars.dart';

class BuildRestaurantsDB extends StatefulWidget {
  @override
  State<BuildRestaurantsDB> createState() => _BuildRestaurantsDBState();
}

class _BuildRestaurantsDBState extends State<BuildRestaurantsDB> {
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll("Images/restaurants/");
  }

  @override
  Widget build(BuildContext context) {
    List<Restaurant> dadosRestaurant = [];
    Widget buildFile(BuildContext context, FirebaseFile file) {
      List<Widget> gestureList = [];
      gestureList.add(
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RestaurantScreen(
                restaurant: dadosRestaurant[0],
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                width: 1.0,
                color: Colors.grey[200],
              ),
            ),
            child: Row(
              children: [
                Hero(
                  tag: file.url,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      height: 150.0,
                      width: 150.0,
                      image: NetworkImage(
                        file.url,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dadosRestaurant[0].name.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        //RatingStars(restaurant.rating),
                        RatingStars(dadosRestaurant[0].rating),
                        Text(
                          dadosRestaurant[0].address.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "0.2 miles away",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      dadosRestaurant.removeAt(0);
      return Column(
        children: gestureList,
      );
    }

    return FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text("Some error occurred!"),
              );
            } else {
              final files = snapshot?.data;
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height +
                          MediaQuery.of(context).size.height / 5.5,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          restaurants.forEach((Restaurant restaurant) {
                            dadosRestaurant.add(restaurant);
                          });
                          return buildFile(context, file);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}
