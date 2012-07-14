Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2GNHfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:35:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2GNHfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:35:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: ARM: Samsung SoC fixes for 3.5-rc
Date: Sat, 14 Jul 2012 07:35:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207140735.29019.arnd@arndb.de>
X-Provags-ID: V02:K0:719MidThC/4nsl4wDdcugSArxJ4rRDuiwQ7ioSDzWN9
 ht9UShsdFHFuhqg6tW46WFCHptQBNOerEERj468IYBvg87/uXg
 D9kU1eM5I/Wrsrjz933+1EmoxL41sqW4LkCYLaE1vFgQcrAt/u
 hxFXdWX4xWWwDWvD/wSE/GLe6iow5yQR6FK+1KpssdZV8NDeUj
 bxms/9Q8+duhnHLud6R64zWhOz/q3VwWku5xSZS+knE5Tk9ptt
 Bq5ZBVpiy0KP/oHoVuLdInmuKIuj5OaV/1O4BCAzYu7/H2xfWT
 wlS8JLHHVF6vQrady4rmS95UMwD2JDeGeZDMUQaJGgKfZMuHfF
 xua4DS6CcfvVsUDDbZAY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a second set of fixes for this -rc, all for the samsung platforms.

	Arnd
---
The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to df4732abf91fa394bea95d912aff718ef5e2be5d:

  Merge branch 'v3.5-samsung-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2012-07-14 09:14:35 +0200)

----------------------------------------------------------------

ARM: Samsung SoC fixes for 3.5-rc

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge branch 'v3.5-samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Marek Szyprowski (2):
      ARM: EXYNOS: read initial state of power domain from hw registers
      ARM: EXYNOS: register devices in 'need_restore' state for pm_domains

Sylwester Nawrocki (2):
      ARM: S3C24XX: Correct AC97 clock control bit for S3C2440
      ARM: S3C24XX: Correct CAMIF interrupt definitions

Todd Poynor (1):
      ARM: SAMSUNG: fix race in s3c_adc_start for ADC

Tushar Behera (1):
      ARM: SAMSUNG: Update default rate for xusbxti clock

 arch/arm/mach-exynos/pm_domains.c     |   13 +++++++++----
 arch/arm/mach-s3c24xx/clock-s3c2440.c |    2 +-
 arch/arm/plat-samsung/adc.c           |    8 +++++---
 arch/arm/plat-samsung/devs.c          |    3 ++-
 arch/arm/plat-samsung/s5p-clock.c     |    1 +
 5 files changed, 18 insertions(+), 9 deletions(-)
