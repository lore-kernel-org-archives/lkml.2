Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1IVGW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:22:26 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:58556 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab1IVGWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:22:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 0/4] AB5500 core patches
Date: Thu, 22 Sep 2011 08:22:09 +0200
Message-ID: <1316672529-7630-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Mattias is on leave, so I've broken out debugfs portions of the
AB5500 driver as an add-on patch at Sam's request.

Now I'm also deleting the unused AB3550 driver. Let's keep to the
drivers that are actually being used.

Linus Walleij (2):
  mfd/ab5500: break out debugfs code
  mfd/ab3550: delete AB3550 driver

Mattias Wallin (2):
  mfd: ab5500 chip register access
  mach-ux500: ab5500 platform code added

 arch/arm/mach-u300/i2c.c               |   51 +--
 arch/arm/mach-u300/include/mach/irqs.h |    7 -
 arch/arm/mach-ux500/board-u5500.c      |   29 +-
 drivers/mfd/Kconfig                    |   31 +-
 drivers/mfd/Makefile                   |    3 +-
 drivers/mfd/ab3550-core.c              | 1380 ------------------------------
 drivers/mfd/ab5500-core.c              | 1439 ++++++++++++++++++++++++++++++++
 drivers/mfd/ab5500-core.h              |   87 ++
 drivers/mfd/ab5500-debugfs.c           |  806 ++++++++++++++++++
 drivers/mfd/ab5500-debugfs.h           |   22 +
 include/linux/mfd/ab5500/ab5500.h      |  140 +++
 include/linux/mfd/abx500.h             |   52 +--
 12 files changed, 2545 insertions(+), 1502 deletions(-)
 delete mode 100644 drivers/mfd/ab3550-core.c
 create mode 100644 drivers/mfd/ab5500-core.c
 create mode 100644 drivers/mfd/ab5500-core.h
 create mode 100644 drivers/mfd/ab5500-debugfs.c
 create mode 100644 drivers/mfd/ab5500-debugfs.h
 create mode 100644 include/linux/mfd/ab5500/ab5500.h

-- 
1.7.3.2

