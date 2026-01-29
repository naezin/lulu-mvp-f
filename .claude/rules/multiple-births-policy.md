# Multiple Births Policy (MVP-F)

## 다태아 중심 설계 원칙

### 1. 단태아 가정 금지

```dart
// WRONG: 단태아 가정
final baby = babyProvider.currentBaby;  // 단일 아기만 가정

// CORRECT: 다태아 고려
final family = familyProvider.currentFamily;
final babies = family.babies;
final selectedBaby = babies.firstWhere((b) => b.id == selectedBabyId);
```

### 2. 교정연령 개별 계산

각 아기마다 독립적으로 교정연령을 계산해야 합니다.

```dart
// 아기별 교정연령 사용
for (final baby in babies) {
  final correctedAge = baby.correctedAgeInMonths;
  // 아기별 처리
}
```

### 3. 동시 기록 지원

"둘 다" 버튼으로 여러 아기에게 동시에 기록할 수 있어야 합니다.

```dart
// 다중 아기 ID 지원
Future<void> saveActivity({
  required List<String> babyIds,  // 여러 아기 ID 가능
  required ActivityType type,
  // ...
});
```

### 4. UI 고려사항

- BabyTabBar: 아기 전환 탭 (상단)
- BabySelector: "둘 다" 버튼 포함
- 아기별 색상 구분 (LuluColors.babyColors)

## 금지 표현

- 쌍둥이 "우열" 비교 금지
- "정상/비정상" 판단 표현 금지
- "첫째가 더 잘한다" 등 비교 문구 금지
