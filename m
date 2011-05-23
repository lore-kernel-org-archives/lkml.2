Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1EWI1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:27:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53723 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1EWI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:27:36 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-3c-4dda1a75e4b0
Date: Mon, 23 May 2011 17:27:28 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH v2 0/4] Samsung: Move Samsung SoCs GPIO drivers to	drivers/gpio
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org
Message-id: <20110523082728.GA6192@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 23 May 2011 08:27:33.0126 (UTC)
 FILETIME=[43578260:01CC1923]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dcb4a1f0e0367efb813907e5083998bbb98b0456:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6 (2011-05-21 12:25:07 -0700)

Kyungmin Park (4):
      Move to Samsung common GPIO library to drivers/gpio
      Move the exynos4 GPIO to drivers/gpio
      Move the s5pv210 GPIO to drivers/gpio
      Move the s5pc100 GPIO to drivers/gpio

Changelog v2:
	Use the gpio-* prefix by Grant

Note that: gpio-samsung.c will be used as common samsung gpio file

 arch/arm/mach-exynos4/Makefile     |    2
 arch/arm/mach-exynos4/gpiolib.c    |  365 ------------------------------------
 arch/arm/mach-s5pc100/Makefile     |    2
 arch/arm/mach-s5pc100/gpiolib.c    |  355 -----------------------------------
 arch/arm/mach-s5pv210/Makefile     |    2
 arch/arm/mach-s5pv210/gpiolib.c    |  288 -----------------------------
 arch/arm/plat-samsung/Makefile     |    1
 arch/arm/plat-samsung/gpiolib.c    |  206 --------------------
 b/arch/arm/mach-exynos4/Makefile   |    2
 b/arch/arm/mach-s5pc100/Makefile   |    2
 b/arch/arm/mach-s5pv210/Makefile   |    2
 b/arch/arm/plat-samsung/Makefile   |    1
 b/drivers/gpio/Kconfig             |   24 ++
 b/drivers/gpio/Makefile            |    4
 b/drivers/gpio/gpio-exynos4.c      |  366 ++++++++++++++++++++++++++++++++++++-
 b/drivers/gpio/gpio-plat-samsung.c |  207 ++++++++++++++++++++
 b/drivers/gpio/gpio-s5pc100.c      |  356 +++++++++++++++++++++++++++++++++++
 b/drivers/gpio/gpio-s5pv210.c      |  289 +++++++++++++++++++++++++++++
 b/drivers/gpio/samsung-gpiolib.c   |    3
 drivers/gpio/Kconfig               |   24 ++
 drivers/gpio/Makefile              |    4
 21 files changed, 1278 insertions(+), 1227 deletions(-)
