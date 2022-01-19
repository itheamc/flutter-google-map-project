// Address Model

class Address {
  int? id;
  String? suite;
  String? street;
  String? city;
  String? zipcode;
  String? district;
  String? state;
  Geo? geo;
  String? receiver;
  String? phone;
  String? addressType;

  Address(
    {this.id,
      this.suite,
      this.street,
      this.city,
      this.zipcode,
      this.district,
      this.state,
      this.geo,
      this.receiver,
      this.phone,
      this.addressType});

factory Address.fromJson(dynamic json) {
  return Address(
      id: json['id'],
      suite: json['suite'],
      street: json['street'],
      city: json['city'],
      zipcode: json['zipcode'],
      district: json['district'],
      state: json['state'],
      geo: json['geo'] != null ? Geo.fromJson(json['geo']) : null,
      receiver: json['receiver'],
      phone: json['phone'],
      addressType: json['address_type']
  );
}

Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['id'] = id;
  map['suite'] = suite;
  map['street'] = street;
  map['city'] = city;
  map['zipcode'] = zipcode;
  map['district'] = district;
  map['state'] = state;
  if (geo != null) {
    map['geo'] = geo?.toJson();
  }
  map['receiver'] = receiver;
  map['phone'] = phone;
  map['address_type'] = addressType;
  return map;
}

String get fullAddress {
  var address = [suite, street, city, district, state];
  address.removeWhere((element) => element == null || element.trim().isEmpty);
  return address.join(", ");
}
}

// Geo Model
class Geo {
  num? lat;
  num? lng;

  Geo({
    this.lat,
    this.lng,
  });

  factory Geo.fromJson(dynamic json) {
    return Geo(
        lat: json['lat'],
        lng: json['lng']
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}