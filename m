Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3ACKr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:47:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18757 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3ACKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:47:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 Jan 2013 02:47:21 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <linus.walleij@linaro.org>,
        <grant.likely@secretlab.ca>, <akpm@linux-foundation.org>
CC: <a.zummo@towertech.it>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] mfd: palma: add RTC and GPIO support
Date: Thu, 3 Jan 2013 16:16:56 +0530
Message-ID: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the RTC and gpio driver for the TI Palma series PMIC.
The changes are splitted so that easy to apply in different sub systems.

Laxman Dewangan (4):
  mfd: palmas: add rtc irq number as irq resource for palmas-rtc
  mfd: palmas: add apis to access the Palmas' registers
  gpio: palmas: Add support for Palams GPIO
  rtc: palmas: add RTC driver Palmas series PMIC

 drivers/gpio/Kconfig       |    7 +
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-palmas.c |  184 ++++++++++++++++++++++++
 drivers/mfd/palmas.c       |   14 ++-
 drivers/rtc/Kconfig        |   10 ++
 drivers/rtc/Makefile       |    1 +
 drivers/rtc/rtc-palmas.c   |  339 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h |   52 +++++++
 8 files changed, 606 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpio/gpio-palmas.c
 create mode 100644 drivers/rtc/rtc-palmas.c

