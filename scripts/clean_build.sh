#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════
# Lulu MVP-F - 빌드 정리 스크립트
# 용도: 빌드 캐시 및 아티팩트 완전 정리로 빌드 성능 개선
# 사용: ./scripts/clean_build.sh
# ═══════════════════════════════════════════════════════════════════════

set -e  # 에러 발생 시 즉시 중단

echo "Lulu MVP-F 빌드 정리 시작..."
echo ""

# ─────────────────────────────────────────────────────────────────────────
# 1. Flutter Clean
# ─────────────────────────────────────────────────────────────────────────
echo "Flutter clean..."
flutter clean
echo "Flutter clean 완료"
echo ""

# ─────────────────────────────────────────────────────────────────────────
# 2. iOS 특화 정리
# ─────────────────────────────────────────────────────────────────────────
if [ -d "ios" ]; then
  echo "iOS 빌드 아티팩트 정리..."
  cd ios

  # Pods 디렉토리 삭제
  if [ -d "Pods" ]; then
    echo "  - Pods 디렉토리 삭제 중..."
    rm -rf Pods/
  fi

  # iOS 빌드 디렉토리 삭제
  if [ -d "build" ]; then
    echo "  - iOS build 디렉토리 삭제 중..."
    rm -rf build/
  fi

  # Podfile.lock 삭제
  if [ -f "Podfile.lock" ]; then
    echo "  - Podfile.lock 삭제 중..."
    rm Podfile.lock
  fi

  # .symlinks 정리
  if [ -d ".symlinks" ]; then
    echo "  - .symlinks 디렉토리 삭제 중..."
    rm -rf .symlinks/
  fi

  # Pod deintegrate (cocoapods-deintegrate 설치 필요)
  if command -v pod &> /dev/null; then
    echo "  - Pod deintegrate 실행 중..."
    pod deintegrate || echo "  Pod deintegrate 실패 (무시하고 계속)"
  fi

  cd ..
  echo "iOS 정리 완료"
  echo ""
fi

# ─────────────────────────────────────────────────────────────────────────
# 3. Android 특화 정리
# ─────────────────────────────────────────────────────────────────────────
if [ -d "android" ]; then
  echo "Android 빌드 아티팩트 정리..."

  # Gradle 캐시 정리
  if [ -d "android/.gradle" ]; then
    echo "  - Gradle 캐시 삭제 중..."
    rm -rf android/.gradle/
  fi

  # Android 빌드 디렉토리 삭제
  if [ -d "android/build" ]; then
    echo "  - Android build 디렉토리 삭제 중..."
    rm -rf android/build/
  fi

  if [ -d "android/app/build" ]; then
    echo "  - Android app build 디렉토리 삭제 중..."
    rm -rf android/app/build/
  fi

  echo "Android 정리 완료"
  echo ""
fi

# ─────────────────────────────────────────────────────────────────────────
# 4. Dart/Flutter 캐시 정리
# ─────────────────────────────────────────────────────────────────────────
echo "Dart 캐시 정리..."

# .dart_tool 디렉토리 삭제
if [ -d ".dart_tool" ]; then
  echo "  - .dart_tool 디렉토리 삭제 중..."
  rm -rf .dart_tool/
fi

# build 디렉토리 삭제
if [ -d "build" ]; then
  echo "  - build 디렉토리 삭제 중..."
  rm -rf build/
fi

echo "Dart 캐시 정리 완료"
echo ""

# ─────────────────────────────────────────────────────────────────────────
# 5. Pub Cache Repair (선택적)
# ─────────────────────────────────────────────────────────────────────────
read -p "Flutter pub cache repair를 실행하시겠습니까? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Pub cache repair 실행 중..."
  flutter pub cache repair
  echo "Pub cache repair 완료"
  echo ""
fi

# ─────────────────────────────────────────────────────────────────────────
# 6. 완료 안내
# ─────────────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "빌드 정리 완료!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "다음 단계:"
echo "  1. flutter pub get          - 의존성 재설치"
echo "  2. cd ios && pod install    - iOS Pod 재설치 (iOS 개발 시)"
echo "  3. flutter run              - 앱 실행"
echo ""
echo "Tip: 이 스크립트는 월 1회 실행을 권장합니다."
echo ""
