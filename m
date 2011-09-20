Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1ITVVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:21:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1ITVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:21:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for v3.1-rc7
Date: Tue, 20 Sep 2011 23:21:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, nicolas.pitre@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109202321.30320.arnd@arndb.de>
X-Provags-ID: V02:K0:WXfwG1QKqPS2sgI950Sd6EAGKr3oN+uvniEUl69UT9e
 cuAeMCDTKD22uzcFCRwH1jwqSB1xnA+9bPBza2DLkIg+dLMXd7
 k/ovEyZbLqt45hy8Hldk0gYwpfMfaorpR4G7AzLxoDkYfwF73K
 W4NCqTkXveG5BPaBUx8PtmSPb9HQhgOT2Z/XSu0iSE9uDBSsWm
 LCqAxy4S3FJw/9WofSRrmyiyc2Kml5fV7kQcdy01S2Ffde78UZ
 SDXNXBPfXRKZxITeEMBnoNYSQkHYVRi8w9oS1AzlH+9mSseNsK
 SxgdOLbHeUM/h+xu3MtAoE7K0uTosc6qZecKkWG9UolPw9ZjtV
 eRybe7newQskZmh8O9z0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the latest bug fixes for integration into 3.1. It's mostly
samsung stuff, which was missing in the last round, plus three
small regression fixes in other platforms. 

Please pull for the next -rc.

Thanks,

	Arnd

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://git.linaro.org/people/arnd/arm-soc.git fixes

Arnd Bergmann (1):
      Merge branch 'samsung-fixes-2' of git://github.com/kgene/linux-samsung into HEAD

Banajit Goswami (1):
      ARM: S3C64XX: Remove un-used code backlight code on SMDK6410

Changhwan Youn (1):
      ARM: EXYNOS4: restart clocksource while system resumes

Jonghwan Choi (1):
      ARM: EXYNOS4: Fix wrong pll type for vpll

Kukjin Kim (3):
      ARM: EXYNOS4: Fix return type of local_timer_setup()
      ARM: EXYNOS4: Fix routing timer interrupt to offline CPU
      ARM: SAMSUNG: fix to prevent declaring duplicated

Linus Walleij (1):
      mach-integrator: fix VGA base regression

Marek Szyprowski (1):
      ARM: SAMSUNG: fix watchdog reset issue with clk_get()

Nicolas Pitre (1):
      ARM: Dove: fix second SPI initialization call

Stephen Warren (1):
      arm/dt: Tegra: Update SDHCI nodes to match bindings

Thomas Abraham (1):
      ARM: EXYNOS4: fix incorrect pad configuration for keypad row lines

 arch/arm/boot/dts/tegra-harmony.dts                |   12 +++---
 arch/arm/boot/dts/tegra-seaboard.dts               |    6 ++--
 arch/arm/mach-dove/common.c                        |    2 +-
 arch/arm/mach-exynos4/clock.c                      |    2 +-
 arch/arm/mach-exynos4/mct.c                        |   10 +++++-
 arch/arm/mach-exynos4/platsmp.c                    |    2 +
 arch/arm/mach-exynos4/setup-keypad.c               |   11 +++---
 arch/arm/mach-integrator/integrator_ap.c           |    2 +
 arch/arm/mach-integrator/pci_v3.c                  |    2 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   39 --------------------
 arch/arm/plat-samsung/clock.c                      |   11 ++++++
 arch/arm/plat-samsung/include/plat/clock.h         |    8 ++++
 .../arm/plat-samsung/include/plat/watchdog-reset.h |   10 ++----
 13 files changed, 52 insertions(+), 65 deletions(-)
