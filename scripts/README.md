# Lulu MVP-F Scripts

빌드 및 개발 자동화를 위한 스크립트 모음입니다.

## 사용 가능한 스크립트

### clean_build.sh
빌드 캐시와 아티팩트를 완전히 정리합니다.

```bash
./scripts/clean_build.sh
```

**정리 대상:**
- Flutter 빌드 캐시
- iOS Pods 및 빌드 아티팩트
- Android Gradle 캐시 및 빌드
- .dart_tool 디렉토리

**권장 사용 시점:**
- 월 1회 정기 정리
- 빌드 오류 발생 시
- Flutter/Dart 버전 업그레이드 후

### measure_build_time.sh
빌드 성능을 측정하고 기록합니다.

```bash
./scripts/measure_build_time.sh
```

**측정 항목:**
- Clean Build 시간 (iOS Debug)
- Incremental Build 시간

**목표 기준:**
- Clean Build: < 5분
- Incremental Build: < 30초

**권장 사용 시점:**
- 주 1회 정기 측정
- 빌드 성능 저하 의심 시
- 의존성 대량 추가 후

## 스크립트 실행 권한 부여

```bash
chmod +x scripts/*.sh
```

## 결과 로그

`build_performance_log.txt` 파일에 측정 결과가 누적 기록됩니다.
