Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1GICvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 22:51:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38603 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab1GICu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 22:50:58 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-df-4e17c2108533
Date: Sat, 09 Jul 2011 11:50:52 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 3.0-rc7
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <007801cc3de3$06c33a30$1449ae90$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acw94wPsbTxHwzlFSiCsQKS5VX7cXw==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for bug fix. If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Kukjin Kim (1):
      Merge branch 'for-spi' into s5p-fixes-for-linus

MyungJoo Ham (2):
      ARM: SAMSUNG: header file revised to prevent declaring duplicated
      ARM: EXYNOS4: Address a section mismatch w/ suspend issue.

Naveen Krishna Chatradhi (1):
      ARM: EXYNOS4: fix improper gpio configuration

Padmavathi Venna (3):
      ARM: SAMSUNG: Add tx_st_done variable
      spi/s3c64xx: Bug fix for SPI with different FIFO level
      ARM: S5PC100: Fix for compilation error

Sangbeom Kim (1):
      ARM: S5P: Fix bug on init of PWMTimers for HRTimer

Sylwester Nawrocki (1):
      ARM: EXYNOS4: Set appropriate I2C device variant

Thomas Abraham (1):
      ARM: EXYNOS4: Fix card detection for sdhci 0 and 2

Wolfram Sang (3):
      ARM: S3C24XX: don't use uninitialized variable in dma.c
      ARM: S3C24XX: drop return codes in void function of dma.c
      ARM: S3C2440: fix section mismatch on mini2440

 arch/arm/mach-exynos4/cpu.c                      |    6 ++++++
 arch/arm/mach-exynos4/dev-audio.c                |    2 +-
 arch/arm/mach-exynos4/headsmp.S                  |    2 +-
 arch/arm/mach-exynos4/mach-smdkv310.c            |    8 ++------
 arch/arm/mach-s3c2440/mach-mini2440.c            |    2 +-
 arch/arm/mach-s3c64xx/dev-spi.c                  |    2 ++
 arch/arm/mach-s5p64x0/dev-spi.c                  |    4 ++++
 arch/arm/mach-s5pc100/dev-spi.c                  |    4 ++++
 arch/arm/mach-s5pv210/dev-spi.c                  |    2 ++
 arch/arm/plat-s3c24xx/dma.c                      |   12 +++---------
 arch/arm/plat-s5p/s5p-time.c                     |    4 ++--
 arch/arm/plat-samsung/include/plat/devs.h        |    6 ++++++
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |    2 ++
 drivers/spi/spi_s3c64xx.c                        |    4 +---
 14 files changed, 37 insertions(+), 23 deletions(-)

