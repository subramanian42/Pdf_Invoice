final String tableWeights = 'weights';

class WeightFields {
  static final List<String> allFields = [id, value];
  static final String id = '_id';
  static final String value = 'value';
}

class Weight {
  final num value;
  final int? id;

  const Weight({
    this.id,
    required this.value,
  });
  Weight copy({int? id, num? value}) => Weight(
        id: id ?? this.id,
        value: value ?? this.value,
      );

  Map<String, Object?> toJson() => {
        WeightFields.id: id,
        WeightFields.value: value,
      };

  static Weight fromJson(Map<String, Object?> json) => Weight(
        id: json[WeightFields.id] as int?,
        value: json[WeightFields.value] as num,
      );
}
