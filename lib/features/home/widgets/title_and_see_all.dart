import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/core.dart';

class TitleAndSeeAll extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const TitleAndSeeAll({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.2),
          ),
        ),
        // const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            AppLocalizations.of(context)!.seeAll,
            style: const TextStyle(
                color: ColorsApp.primary, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
