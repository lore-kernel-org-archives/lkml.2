Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2ELXH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 19:07:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36411 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2ELXH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 19:07:27 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Sat, 12 May 2012 16:07:27 -0700
Message-ID: <CAOesGMj+Ds+gOX2mSnYb2Cn3e9894bceisPtsnW5qYhT3SPhsA@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.4
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit e396dbd4ed2ccfd362261b05027bbdccec192b14:

  Merge tag 'omap-fixes-for-v3.4-rc6-take-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into
fixes (2012-05-09 09:03:34 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 85d5c4a362add39f7491b38ed0160df1dcae1d2b:

  Merge branch 'v3.4-samsung-fixes-5' of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
fixes (2012-05-12 15:41:22 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.4-rc

I was hoping to be done with fixes for 3.4 but we got two branches from
subarch maintainers the last couple of days. So here is one last(?) pull
request for arm-soc containing 7 patches:

- 5 of them are for shmobile dealing with SMP setup and compile failures
- The remaining two are for regressions on the Samsung platforms

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      ARM: mach-shmobile: convert mackerel to use the generic MMC GPIO
hotplug helper
      ARM: mach-shmobile: convert ag5evm to use the generic MMC GPIO
hotplug helper

Kukjin Kim (1):
      ARM: EXYNOS: fix ctrlbit for exynos5_clk_pdma1

Kuninori Morimoto (1):
      ARM / mach-shmobile: sh73a0 SMP TWD boot regression fix

Magnus Damm (2):
      ARM / mach-shmobile: r8a7779 SMP TWD boot regression fix
      ARM / mach-shmobile: Invalidate caches when booting secondary cores

Marek Szyprowski (1):
      ARM: EXYNOS: use s5p-timer for UniversalC210 board

Olof Johansson (2):
      Merge branch 'fixes' of git://git.kernel.org/.../rafael/renesas into fixes
      Merge branch 'v3.4-samsung-fixes-5' of
git://git.kernel.org/.../kgene/linux-samsung into fixes

 arch/arm/mach-exynos/Kconfig                 |  3 +++
 arch/arm/mach-exynos/clock-exynos5.c         |  2 +-
 arch/arm/mach-exynos/mach-universal_c210.c   |  4 +++-
 arch/arm/mach-shmobile/board-ag5evm.c        | 22 ++--------------------
 arch/arm/mach-shmobile/board-mackerel.c      | 22 ++--------------------
 arch/arm/mach-shmobile/headsmp.S             | 56
+++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-shmobile/include/mach/common.h |  2 +-
 arch/arm/mach-shmobile/setup-r8a7779.c       |  4 ++++
 arch/arm/mach-shmobile/setup-sh73a0.c        |  4 ++++
 arch/arm/mach-shmobile/smp-r8a7779.c         |  8 +++++++-
 arch/arm/mach-shmobile/smp-sh73a0.c          |  7 ++++++-
 arch/arm/mach-shmobile/timer.c               |  9 ---------
 12 files changed, 88 insertions(+), 55 deletions(-)
