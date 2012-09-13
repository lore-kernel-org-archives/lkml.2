Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2IMHap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:30:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65285 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2IMHal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:30:41 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d9d2:3ecd:9fd1:b4c3]
Date: Thu, 13 Sep 2012 00:30:40 -0700
Message-ID: <CAOesGMhWHQROj_UHisStW_U9PUBgY9W0mvenzuqiwVoTKR-w1Q@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.6-rc6
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 2bc733e8b443e77db5bb18e1bb8f1c535a92eb8c:

  Merge tag 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6
into fixes (2012-09-12 22:00:07 -0700)

----------------------------------------------------------------

arm-soc: bug fixes for v3.6-rc

- A set of OMAP fixes, about half of them PM/clock related, the rest
  scattered over the platform code but all small and targeted to real bugs.
- Two small i.MX fixes for SSI device clock setup.

----------------------------------------------------------------
Aaro Koskinen (2):
      ARM: OMAP: sram: fix OMAP4 errata handling
      ARM: OMAP: sram: skip the first 16K on OMAP3 HS

Fabio Estevam (2):
      ARM: clk-imx25: Fix SSI clock registration
      ARM: clk-imx35: Fix SSI clock registration

Igor Grinberg (1):
      ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER

Misael Lopez Cruz (1):
      ARM: OMAP: hwmod code: Disable module when hwmod enable fails

Olof Johansson (2):
      Merge tag 'omap-fixes-for-v3.6-rc4' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes

Paul Walmsley (2):
      ARM: OMAP3xxx: clockdomain: fix software supervised wakeup/sleep
      Merge branches 'clkdev_fixes_3.6rc', 'clkdm_fixes_3.6rc' and
'hwmod_data_fixes_a_3.6rc' into omap_fixes_a_3.6rc

Radek Pilar (1):
      ARM: OMAP: Config fix for omap3-touchbook board

Tero Kristo (2):
      ARM: OMAP3: hwmod data: fix iva2 reset info
      ARM: OMAP4: hwmod data: temporarily comment out data for the
sl2if IP block

Tony Lindgren (3):
      ARM: OMAP4: Fix array size for irq_target_cpu
      Merge branch 'fixes-wakeupgen' into fixes
      Merge tag 'omap-fixes-a-for-3.6rc' of
git://git.kernel.org/.../pjw/omap-pending into fixes

Vaibhav Hiremath (1):
      ARM: OMAP2+: am33xx: Fix the timer fck clock naming convention

 arch/arm/mach-imx/clk-imx25.c              |  6 ++--
 arch/arm/mach-imx/clk-imx35.c              |  6 ++--
 arch/arm/mach-omap2/Kconfig                |  3 +-
 arch/arm/mach-omap2/Makefile               |  2 +-
 arch/arm/mach-omap2/clock33xx_data.c       | 14 ++++-----
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c | 50 ++++++++++++++++++++++++++++--
 arch/arm/mach-omap2/cm-regbits-34xx.h      |  1 +
 arch/arm/mach-omap2/omap-wakeupgen.c       |  2 +-
 arch/arm/mach-omap2/omap_hwmod.c           |  1 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 15 +++++++--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 12 +++----
 arch/arm/mach-omap2/timer.c                |  7 +++++
 arch/arm/plat-omap/sram.c                  | 11 +++++--
 13 files changed, 98 insertions(+), 32 deletions(-)
