# LULU App ver2 (MVP-F)

> **"20명의 Elite Agent가 다태아+조산아 부모를 위한 최고의 앱을 만든다"**
>
> **Version**: 2.0 (MVP-F)
> **Last Updated**: 2026-01-29
> **Target Release**: 2026.02.17

---

## 프로젝트 개요

### 미션
```
"전 세계 모든 부모가 새벽 3시에도 한 손으로, 5초 안에,
아기의 다음 행동을 예측하고 안심할 수 있는 앱"
```

### MVP-F 컨셉: 균형 하이브리드
```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   MVP-F = 조산아 기능 + 다태아 기능 균형                    │
│                                                             │
│   타겟: 다태아 조산아 부모 (9,500명/년) = 핵심 타겟         │
│         + 조산아 단태아 (7,500명)                           │
│         + 다태아 만삭 (4,000명)                             │
│         = 총 21,000명/년 (90% 커버)                         │
│                                                             │
│   핵심 차별화:                                              │
│   1. 동시 기록 "둘 다" 버튼                                 │
│   2. 개별 교정연령 (아기별)                                 │
│   3. Fenton + WHO 차트 자동 전환                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 핵심 수치
| 지표 | 값 |
|------|-----|
| 한국 다태아/년 | 13,500 (5.7%) |
| 다태아 중 조산율 | 70.8% |
| 조산아+다태아 전용 앱 | 0개 (100% Gap) |
| 목표 NPS | +66.7 |
| 목표 TSR | 92.5% |

---

## 20 Elite Agents

```
┌─────────────────────────────────────────────────────────────┐
│                  20 Elite Agents (v2.0)                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  C-Suite (4)              Domain Specialists (8)            │
│  ├─ CPO                   ├─ Pediatric Advisor              │
│  ├─ CDO                   ├─ Sleep Specialist               │
│  ├─ CTO                   ├─ Developmental Lead             │
│  └─ QA                    ├─ Physical Specialist            │
│                           ├─ Nutrition Specialist           │
│  Quality (3)              ├─ Growth Hacker                  │
│  ├─ User Researcher       ├─ Multiple Births Specialist *   │
│  ├─ Product Auditor       └─ Neonatology Specialist *       │
│  └─ System Architect                                        │
│                           Global & Trust (5)                │
│                           ├─ Localization Lead              │
│                           ├─ Data Scientist                 │
│                           ├─ Content Strategist             │
│                           ├─ Compliance Officer             │
│                           └─ Security Engineer              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 신규 에이전트 역할

| 에이전트 | 역할 | 검토 필수 영역 |
|----------|------|---------------|
| **Multiple Births Specialist** | 다태아 UX 전문가 | 동시기록, 아기전환, 비교 방지 |
| **Neonatology Specialist** | 조산아 전문가 | 교정연령, Fenton, 의료 콘텐츠 |

---

## Tech Stack

```yaml
Framework: Flutter 3.0+
Language: Dart (SDK >=3.0.0 <4.0.0)
Platforms: iOS (MVP), Android (Phase 2)

State Management: Provider ^6.1.1
Backend: Firebase (Auth, Firestore, Functions)
AI: OpenAI GPT-4

Design:
  Theme: Midnight Blue (Dark Mode First)
  System: Glassmorphism
  Grid: 4px spacing
```

---

## 데이터 모델 (다태아 중심 설계)

### 핵심 모델

```dart
/// 가족 모델 - 최상위 컨테이너
class FamilyModel {
  final String id;
  final String name;
  final List<BabyModel> babies;  // 1-4명
  final DateTime createdAt;

  BabyModel? get activeBaby;     // 현재 선택된 아기
  bool get isMultiple => babies.length > 1;
}

/// 아기 모델 - 다태아 고려 설계
class BabyModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final int? gestationalWeeks;   // null = 만삭 (40주)
  final int? birthWeightGrams;
  final BabyType type;           // singleton, twin, triplet+
  final int? birthOrder;         // 다태아: 1, 2, 3...

  // 교정연령 (개별 계산)
  int? get correctedAgeInWeeks {
    if (gestationalWeeks == null || gestationalWeeks! >= 37) return null;
    final actualDays = DateTime.now().difference(birthDate).inDays;
    final correctionDays = (40 - gestationalWeeks!) * 7;
    return ((actualDays - correctionDays) / 7).floor();
  }

  // Fenton vs WHO 차트 선택
  GrowthChart get recommendedChart {
    if (gestationalWeeks == null || gestationalWeeks! >= 37) {
      return GrowthChart.who;
    }
    final totalWeeks = gestationalWeeks! + (correctedAgeInWeeks ?? 0);
    return totalWeeks < 50 ? GrowthChart.fenton : GrowthChart.who;
  }

  bool get isPreterm => gestationalWeeks != null && gestationalWeeks! < 37;
}

enum BabyType { singleton, twin, triplet, quadruplet }
enum GrowthChart { fenton, who }
```

### 활동 기록 모델

```dart
/// 활동 기록 - 다태아 동시 기록 지원
class ActivityRecord {
  final String id;
  final List<String> babyIds;    // 다태아: 여러 ID 가능
  final ActivityType type;
  final DateTime startTime;
  final DateTime? endTime;
  final Map<String, dynamic> data;  // 타입별 상세 데이터

  bool get isSimultaneous => babyIds.length > 1;
}

enum ActivityType { sleep, feeding, diaper, play, health }

/// 수유 상세 데이터
class FeedingData {
  final FeedingType type;        // breast, bottle, solid
  final Map<String, int>? amountByBaby;  // 아기별 양 (ml)
  final int? durationMinutes;
}
```

---

## 핵심 화면 스펙

### 1. 온보딩 플로우

```
Step 1: 환영 → Step 2: 아기 수 (1/2/3/4+)
→ Step 3: 첫째 정보 (이름, 출생일, 조산아?)
→ [조산아] Step 3b: 출생주수, 체중
→ [다태아] Step 4: 둘째 정보 (반복)
→ [다태아] Step 5: 동시 기록 팁
→ Step 6: 완료
```

### 2. 홈 대시보드

```
┌─────────────────────────────────────────┐
│  [ 서준이 ]  [ 서윤이 ]  [ 둘 다 ]      │  ← 아기 전환 탭
│─────────────────────────────────────────│
│  Sweet Spot: 14:30 (25분 후)            │
│  교정연령: 2개월 1주                     │
│─────────────────────────────────────────│
│  마지막 수유        마지막 수면          │
│  12:45 (1h전)      10:00-12:30          │
│─────────────────────────────────────────│
│  오늘: 수유 4회 | 수면 8h | 기저귀 6     │
└─────────────────────────────────────────┘
```

### 3. 동시 기록 화면

```
┌─────────────────────────────────────────┐
│  ← 수유 기록                            │
│─────────────────────────────────────────│
│  누구에게?                              │
│  [서준이]  [서윤이]  [둘 다]            │
│─────────────────────────────────────────│
│  종류: [모유]  [분유]  [이유식]         │
│─────────────────────────────────────────│
│  양 (각각)                              │
│  서준이: [120]ml   서윤이: [110]ml      │
│─────────────────────────────────────────│
│           [ 저장하기 ]                  │
└─────────────────────────────────────────┘
```

---

## 의료 알고리즘

### 교정연령 계산

```dart
/// Neonatology Specialist 검증 필수
int calculateCorrectedAgeWeeks(DateTime birthDate, int gestationalWeeks) {
  final actualDays = DateTime.now().difference(birthDate).inDays;
  final correctionDays = (40 - gestationalWeeks) * 7;
  return ((actualDays - correctionDays) / 7).floor();
}

// 적용 범위
// - 성장 차트: 만 2세까지
// - 발달 마일스톤: 만 2세까지
// - Sweet Spot: 만 1세까지
```

### Fenton → WHO 전환

```dart
GrowthChart selectChart(int gestationalWeeks, int actualAgeWeeks) {
  if (gestationalWeeks >= 37) return GrowthChart.who;

  final totalWeeks = gestationalWeeks + actualAgeWeeks;
  return totalWeeks < 50 ? GrowthChart.fenton : GrowthChart.who;
}

// 전환 시 UX: 안내 메시지 + 이전 기록 유지
```

### 쌍둥이 체중 불일치

```dart
/// Multiple Births Specialist 검증 필수
DiscordanceLevel checkDiscordance(double weight1, double weight2) {
  final larger = max(weight1, weight2);
  final smaller = min(weight1, weight2);
  final percent = (larger - smaller) / larger * 100;

  if (percent < 15) return DiscordanceLevel.normal;
  if (percent < 20) return DiscordanceLevel.caution;
  if (percent < 25) return DiscordanceLevel.warning;
  return DiscordanceLevel.severe;
}
```

---

## 디자인 시스템

### 색상

```dart
class LuluColors {
  // 배경
  static const midnightNavy = Color(0xFF0D1B2A);
  static const deepBlue = Color(0xFF1B263B);
  static const surfaceElevated = Color(0xFF2A3F5F);

  // 강조
  static const lavenderMist = Color(0xFF9D8CD6);
  static const champagneGold = Color(0xFFD4AF6A);

  // 텍스트
  static const textPrimary = Color(0xFFE9ECEF);
  static const textSecondary = Color(0xFFADB5BD);

  // 아기 구분 색상 (다태아)
  static const baby1Color = Color(0xFF7EB8DA);  // 하늘
  static const baby2Color = Color(0xFFE8B4CB);  // 분홍
  static const baby3Color = Color(0xFFA8D5BA);  // 민트
  static const baby4Color = Color(0xFFF5D6A8);  // 살구
}
```

### 간격 (4px Grid)

```dart
class LuluSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
}
```

---

## MVP-F 기능 체크리스트

### Phase 1 (MVP) - 출시 필수

| 기능 | 우선순위 | 상태 |
|------|---------|------|
| 다태아 등록 (2-4명) | P0 | [ ] |
| 아기 전환 탭 | P0 | [ ] |
| 동시 기록 "둘 다" 버튼 | P0 | [ ] |
| 개별 교정연령 자동 | P0 | [ ] |
| Fenton 차트 | P0 | [ ] |
| WHO 차트 전환 | P0 | [ ] |
| Sweet Spot (교정연령) | P0 | [ ] |
| 5종 기록 | P0 | [ ] |
| 홈 대시보드 (다태아) | P0 | [ ] |
| 위젯 | P1 | [ ] |
| 온보딩 | P0 | [ ] |

### Phase 2 - 출시 후

| 기능 | 예정 |
|------|------|
| 비교 대시보드 | Q2 |
| NICU 퇴원 가이드 | Q2 |
| AI 코칭 | Q2 |
| 공동 양육 | Q2 |
| Android | Q2 |

---

## 금지 사항 (Forbidden)

### 코드
```
- 하드코딩된 API 키
- print문 (debugPrint 사용)
- 빈 catch 블록
- TODO 없이 임시 코드
- 강제 언래핑 (!!)
```

### UX
```
- 쌍둥이 "우열" 비교 표현
- "정상/비정상" 판단 표현
- 의료 진단/치료 표현
- 3초 이상 걸리는 핵심 동작
```

### 의료
```
- "진단합니다", "치료합니다"
- 의료기기 암시 표현
- 출처 없는 의학 수치
```

---

## 커밋 규칙

```yaml
Format: <type>(<scope>): <description>

Types:
  feat: 새 기능
  fix: 버그 수정
  refactor: 리팩토링
  style: 포맷팅
  docs: 문서
  test: 테스트

Scopes:
  onboarding, multiple, preterm, record, dashboard, widget, chart
```

---

## 관련 문서

| 문서 | 내용 |
|------|------|
| Master Strategy v1.3 | 전체 사업 전략 |
| MVP-F UT Report v2.0 | 6개 MVP x 6명 UT 결과 |
| Multiple Births Analysis | 다태아 데이터 분석 |

---

**Last Updated**: 2026-01-29
**Version**: 2.0 (MVP-F)
**Agents**: 20
