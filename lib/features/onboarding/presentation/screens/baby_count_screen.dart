import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/onboarding_provider.dart';

/// Step 2: 아기 수 선택
/// [1명] [2명] [3명] [4명+]
class BabyCountScreen extends StatelessWidget {
  const BabyCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),

          // 질문 텍스트
          Text(
            '아기가 몇 명인가요?',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          Text(
            '다둥이 가정도 함께 할 수 있어요',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),

          const SizedBox(height: 48),

          // 아기 수 선택 그리드
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _BabyCountCard(
                  count: 1,
                  label: '1명',
                  emoji: '👶',
                  isSelected: provider.babyCount == 1,
                  onTap: () => provider.setBabyCount(1),
                ),
                _BabyCountCard(
                  count: 2,
                  label: '쌍둥이',
                  emoji: '👶👶',
                  isSelected: provider.babyCount == 2,
                  onTap: () => provider.setBabyCount(2),
                ),
                _BabyCountCard(
                  count: 3,
                  label: '세쌍둥이',
                  emoji: '👶👶👶',
                  isSelected: provider.babyCount == 3,
                  onTap: () => provider.setBabyCount(3),
                ),
                _BabyCountCard(
                  count: 4,
                  label: '네쌍둥이',
                  emoji: '👶👶👶👶',
                  isSelected: provider.babyCount == 4,
                  onTap: () => provider.setBabyCount(4),
                ),
              ],
            ),
          ),

          // 다음 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.canProceed ? () => provider.nextStep() : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: AppTheme.lavenderMist,
                foregroundColor: AppTheme.midnightNavy,
                disabledBackgroundColor: AppTheme.surfaceElevated,
                disabledForegroundColor: AppTheme.textTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _BabyCountCard extends StatelessWidget {
  final int count;
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _BabyCountCard({
    required this.count,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lavenderMist.withValues(alpha: 0.15) : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.lavenderMist : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: count > 2 ? 24 : 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppTheme.lavenderGlow : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
