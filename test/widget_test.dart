import 'dart:async';

import 'package:countries/utils/sample_data.dart';
import 'package:countries/widgets/country_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/src/core/observable_query.dart';

import 'package:countries/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}
class MockObservableQuery extends Mock implements ObservableQuery {}

void main() {
  final MockGraphQLClient mockGqlClient = MockGraphQLClient();
  final MockObservableQuery mockObservableQuery = MockObservableQuery();
  final ValueNotifier<MockGraphQLClient> mockClient = ValueNotifier(mockGqlClient);

  testWidgets('Connection failure test', (WidgetTester tester) async {
    StreamController<QueryResult> controller;
    QueryResult queryResult;

    controller = StreamController<QueryResult>();
    queryResult = QueryResult(data: null, loading: false);

    when(mockObservableQuery.stream).thenAnswer((_) => controller.stream);
    when(mockGqlClient.watchQuery(any)).thenReturn(mockObservableQuery);

    controller.add(queryResult);

    await tester.pumpWidget(CountriesApp(client: mockClient));
    expect(find.text('Countries'), findsOneWidget);

    await controller.close();
  });

  testWidgets('Loading indicator test', (WidgetTester tester) async {
    StreamController<QueryResult> controller;
    controller = StreamController<QueryResult>();

    when(mockObservableQuery.stream).thenAnswer((_) => controller.stream);
    when(mockGqlClient.watchQuery(any)).thenReturn(mockObservableQuery);

    await tester.pumpWidget(CountriesApp(client: mockClient));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await controller.close();
  });

  testWidgets('Country tiles test', (WidgetTester tester) async {
    StreamController<QueryResult> controller;
    QueryResult queryResult;

    controller = StreamController<QueryResult>();
    queryResult = QueryResult(data: sampleCountries, loading: false);

    when(mockObservableQuery.stream).thenAnswer((_) => controller.stream);
    when(mockGqlClient.watchQuery(any)).thenReturn(mockObservableQuery);

    controller.add(queryResult);

    await tester.pumpWidget(CountriesApp(client: mockClient));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.byType(CountryTile), findsWidgets);

    await tester.tap(find.text('Afghanistan'));
    await tester.pump();

    expect(find.byIcon(FontAwesomeIcons.globeAsia), findsOneWidget);
    expect(find.text('Asia'), findsOneWidget);

    await controller.close();
  });

  testWidgets('Filtered country tiles test', (WidgetTester tester) async {
    StreamController<QueryResult> controller;
    QueryResult queryResult;
    WatchQueryOptions queryOptions;

    controller = StreamController<QueryResult>();
    queryResult = QueryResult(data: sampleCountries, loading: false);
    queryOptions = WatchQueryOptions(document: '');

    when(mockObservableQuery.stream).thenAnswer((_) => controller.stream);
    when(mockObservableQuery.options).thenReturn(queryOptions);
    when(mockGqlClient.watchQuery(any)).thenReturn(mockObservableQuery);

    controller.add(queryResult);

    await tester.pumpWidget(CountriesApp(client: mockClient));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    await tester.enterText(find.byType(TextField), 'an');
    await tester.pump();

    expect(find.byType(CountryTile), findsNWidgets(5));

    await controller.close();
  });
}
