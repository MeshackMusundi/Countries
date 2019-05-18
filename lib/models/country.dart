class Country {
  String name, continent, phone, currency, emoji;
  List<String> languages;

  Country({
    this.name,
    this.continent,
    this.phone,
    this.currency,
    this.emoji,
    this.languages,
  });

  Country.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    continent = map['continent']['name'];
    phone = map['phone'];
    currency = map['currency'];
    emoji = map['emoji'];
    languages = (map['languages'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map<String>((l) => l['name'])
        .toList();
  }
}
