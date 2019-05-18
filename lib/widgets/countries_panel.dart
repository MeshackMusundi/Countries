import 'package:countries/models/country.dart';
import 'package:countries/utils/countries_gql.dart';
import 'package:countries/widgets/country_tile.dart';
import 'package:countries/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountriesPanel extends StatefulWidget {
  @override
  _CountriesPanelState createState() => _CountriesPanelState();
}

class _CountriesPanelState extends State<CountriesPanel> {
  List<Map<String, dynamic>> allCountries;
  List<Map<String, dynamic>> countries;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Query(
        options: QueryOptions(
          document: countriesGraphQL.countriesQuery,
          pollInterval: 10,
        ),
        builder: (QueryResult result, {VoidCallback refetch}) {
          if (result.loading) {
            return Center(child: const CircularProgressIndicator());
          }

          if (result.data == null) {
            return info(
              icon: Icons.cloud_queue,
              text: 'Connect to the internet',
            );
          }

          allCountries = (result.data['countries'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
          countries ??= allCountries;

          return Column(
            children: <Widget>[
              searchField(),
              countriesList(),
            ],
          );
        },
      ),
    );
  }

  Widget info({IconData icon, String text}) {
    Color color = Colors.grey;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 60, color: color),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: color))
        ],
      ),
    );
  }

  Widget searchField() {
    return Container(
      width: double.infinity,
      height: 38,
      margin: const EdgeInsets.all(15.0),
      child: SearchBox(textChanged: onSearchTextChanged),
    );
  }

  void onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) countries = allCountries;

      countries = allCountries.where((c) {
        String country = (c['name'] as String).toLowerCase();
        String filter = text.toLowerCase();
        return country.contains(filter);
      }).toList();
    });
  }

  Widget countriesList() {
    return Expanded(
      child: countries.length == 0
          ? info(icon: FontAwesomeIcons.globe, text: 'No countries')
          : ListView.builder(
              itemCount: countries == null ? 0 : countries.length,
              itemBuilder: (_, int index) {
                Country country = Country.fromMap(countries[index]);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: CountryTile(country: country),
                );
              },
            ),
    );
  }
  
}
