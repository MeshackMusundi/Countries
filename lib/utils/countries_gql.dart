import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CountriesGraphQL {
  static final CountriesGraphQL _internal = CountriesGraphQL.internal();
  factory CountriesGraphQL() => _internal;
  CountriesGraphQL.internal();

  static HttpLink _httpLink = HttpLink(
    uri: 'https://countries.trevorblades.com/',
  );

  static Link _link = _httpLink as Link;

  final ValueNotifier<GraphQLClient> _client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    ),
  );

  ValueNotifier<GraphQLClient> get client => _client;

  String get countriesQuery {
    return '''
    query Countries {
      countries {
        emoji
        name
        continent {
          name
        }
        phone 
        currency
        languages {
          name
        }        
      }
    }
    ''';
  }
}

CountriesGraphQL countriesGraphQL = CountriesGraphQL();
