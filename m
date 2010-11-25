Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0KYEUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:20:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10331 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0KYEUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:20:53 -0500
Date: Thu, 25 Nov 2010 13:21:16 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [GIT PULL] Samsung fixes for 2.6.37-rc4
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Message-id: <008201cb8c58$363980e0$a2ac82a0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcuMWDOSTi8f/+1qQ+GT4jFAQPisng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Samsung fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

These things are for small fix on 2.6.37-rc4.
If any problems, please let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
s5p-fixes-for-linus

Abhilash Kesavan (3):
      ARM: S3C24XX: Fix Demux error in UART3 irqs on S3C2443 and S3C2416
      ARM: S3C24XX: Fix UART3 submask on S3C2416 and S3C2443
      ARM: S5PV210: Fix sysdev related warning messages

Darius Augulis (1):
      ARM: S3C64XX: fix uart clock setup for mini6410/real6410

Kukjin Kim (1):
      ARM: S3C24XX: Fix wrong s3c_gpio_cfgpull

Vasily Khoruzhick (1):
      ARM: S3C2410: Adapt h1940-bluetooth to gpiolib changes

 arch/arm/mach-s3c2410/h1940-bluetooth.c      |    8 ++++----
 arch/arm/mach-s3c2416/irq.c                  |    5 ++---
 arch/arm/mach-s3c2443/irq.c                  |    5 ++---
 arch/arm/mach-s3c64xx/mach-mini6410.c        |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c        |    2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c        |    1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c        |    1 +
 arch/arm/plat-s3c24xx/spi-bus0-gpe11_12_13.c |    6 +++---
 arch/arm/plat-s3c24xx/spi-bus1-gpd8_9_10.c   |    6 +++---
 arch/arm/plat-s3c24xx/spi-bus1-gpg5_6_7.c    |    6 +++---
 10 files changed, 21 insertions(+), 21 deletions(-)

