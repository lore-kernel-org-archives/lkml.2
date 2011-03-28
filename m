Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1C1KvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:51:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58205 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1C1KvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:51:16 -0400
Date: Mon, 28 Mar 2011 19:51:08 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.39-rc1
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <000001cbed36$0f0d0700$2d271500$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvtMJJ68tvdDckXTJa37UspdYly4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for small fixes on 2.6.39-rc1.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

The following changes since commit 18bcd0c8cb7d85a9063b88ec810dc1cdc0974518:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6 (2011-03-27
20:37:50 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Banajit Goswami (1):
      ARM: S5P64X0: Fix iodesc array size for S5P6450

Huang Weiyi (1):
      ARM: S5PV210: Remove duplicated inclusion

Jeongtae Park (2):
      ARM: EXYNOS4: Fix smsc9215 irq polarity on SMDKV310
      ARM: EXYNOS4: Fix smsc9215 irq polarity on SMDKC210

Kukjin Kim (3):
      ARM: EXYNOS4: Fix build warning on regarding SATA_AHCI_PLATFORM
      ARM: SAMSUNG: Fix CPU idmask
      ARM: Suspend: Fix dependency of ARCH_SUSPEND_POSSIBLE

Thomas Abraham (1):
      ARM: EXYNOS4: Fix addruart macro

Vladimir Zapolskiy (1):
      ARM: S5PV210: Fix security engine interrupt names

 arch/arm/Kconfig                                 |    1 +
 arch/arm/mach-exynos4/Kconfig                    |    7 ++++++-
 arch/arm/mach-exynos4/Makefile                   |    2 +-
 arch/arm/mach-exynos4/include/mach/debug-macro.S |    4 ++--
 arch/arm/mach-exynos4/mach-smdkc210.c            |    2 +-
 arch/arm/mach-exynos4/mach-smdkv310.c            |    2 +-
 arch/arm/mach-s5p64x0/cpu.c                      |    2 +-
 arch/arm/mach-s5pv210/include/mach/irqs.h        |    6 +++---
 arch/arm/mach-s5pv210/mach-smdkv210.c            |    1 -
 arch/arm/plat-s5p/cpu.c                          |    8 ++++----
 arch/arm/plat-samsung/init.c                     |    2 +-
 11 files changed, 21 insertions(+), 16 deletions(-)


