import 'baby_type.dart';

/// 가족 모델 - MVP-F 최상위 컨테이너
///
/// 다태아 중심 설계: 1-4명의 아기를 포함하는 가족 단위
class FamilyModel {
  final String id;
  final String userId;
  final List<String> babyIds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FamilyModel({
    required this.id,
    required this.userId,
    required this.babyIds,
    required this.createdAt,
    this.updatedAt,
  });

  /// 다태아 여부 확인
  bool get isMultipleBirth => babyIds.length > 1;

  /// 아기 수
  int get babyCount => babyIds.length;

  /// 출생 유형 반환
  BabyType get birthType => BabyType.fromBabyCount(babyCount);

  /// JSON에서 생성
  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      babyIds: List<String>.from(json['babyIds'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'babyIds': babyIds,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// 복사본 생성 (불변성 유지)
  FamilyModel copyWith({
    String? id,
    String? userId,
    List<String>? babyIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      babyIds: babyIds ?? List.from(this.babyIds),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 아기 추가 (불변성 유지)
  FamilyModel addBaby(String babyId) {
    if (babyIds.length >= 4) {
      throw StateError('가족당 최대 4명의 아기만 등록 가능합니다.');
    }
    return copyWith(
      babyIds: [...babyIds, babyId],
      updatedAt: DateTime.now(),
    );
  }

  /// 아기 제거 (불변성 유지)
  FamilyModel removeBaby(String babyId) {
    if (babyIds.length <= 1) {
      throw StateError('가족에는 최소 1명의 아기가 필요합니다.');
    }
    return copyWith(
      babyIds: babyIds.where((id) => id != babyId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyModel &&
        other.id == id &&
        other.userId == userId &&
        _listEquals(other.babyIds, babyIds);
  }

  @override
  int get hashCode => Object.hash(id, userId, Object.hashAll(babyIds));

  @override
  String toString() {
    return 'FamilyModel(id: $id, userId: $userId, babyCount: $babyCount, '
        'isMultipleBirth: $isMultipleBirth)';
  }
}

/// 리스트 비교 헬퍼
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
