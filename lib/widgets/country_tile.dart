import 'package:countries/models/country.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class CountryTile extends StatelessWidget {
  final Country country;

  CountryTile({Key key, @required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget continentPhoneCurrency = Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Wrap(
        spacing: 15,
        runSpacing: 5,
        children: <Widget>[
          countryInfo(continentIcon(country.continent), country.continent),
          countryInfo(Icons.phone, country.phone),
          countryInfo(MdiIcons.currencySign, country.currency),
        ],
      ),
    );

    return Card(
      child: ExpansionTile(
        leading: Text(country.emoji, style: TextStyle(fontSize: 24)),
        title: Text(country.name),
        children: <Widget>[
          continentPhoneCurrency,
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Divider(height: 1.0),
          ),
          SizedBox(height: 15.0),
          officialLanguages(),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  IconData continentIcon(String continent) {
    if (continent == "Africa") {
      return FontAwesomeIcons.globeAfrica;
    } else if (continent == "Asia" || continent == "Oceania") {
      return FontAwesomeIcons.globeAsia;
    } else if (continent == "Europe") {
      return FontAwesomeIcons.globeEurope;
    } else if (continent == "North America" || continent == "South America") {
      return FontAwesomeIcons.globeAmericas;
    } else {
      return MdiIcons.earth;
    }
  }
  
  final double iconSize = 20.0;
  final double iconTextSpacing = 5.0;

  Widget countryInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: iconSize),
        SizedBox(width: iconTextSpacing),
        Text(text),
      ],
    );
  }

  Widget officialLanguages() {
    Widget icon = SvgPicture.asset(
      'assets/images/language.svg',
      color: Colors.white,
      width: iconSize,
      height: iconSize,
    );
    
    country.languages.removeWhere((s) => s == null);
    String languages = country.languages.join(", ");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          SizedBox(width: iconTextSpacing),
          Text(languages),
        ],
      ),
    );
  }
}
