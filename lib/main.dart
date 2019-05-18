import 'package:countries/utils/countries_gql.dart';
import 'package:countries/widgets/countries_panel.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(CountriesApp(client: countriesGraphQL.client));

class CountriesApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  CountriesApp({Key key, @required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Countries',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: Scaffold(
            appBar: AppBar(title: Text('Countries'), centerTitle: true),
            body: CountriesPanel(),
          ),
        ),
      ),
    );
  }
}
