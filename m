Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0LWIxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:53:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24382 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0LWIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:53:41 -0500
Date: Thu, 23 Dec 2010 17:53:35 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 0/4] MFD MAX8998/LP3974 Driver Update
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 23 Dec 2010 08:53:39.0498 (UTC)
 FILETIME=[E498A8A0:01CBA27E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update at v3
1. Removed independant bugfixes from the patch set.
2. Power Supply API supported.
3. Removed regulators that became useless by introducing Power Supply API.

update at v2
1. Seperated features
2. Added style fixes

v1: "[PATCH] MFD MAX8998/LP3974: Add Features: hibernation, charger,
and other misc."

MyungJoo Ham (4):
  MFD MAX8998/LP3974: Support Hibernation
  MFD MAX8998/LP3974: Support LP3974 RTC
  regulator MAX8998/LP3974: Support DVS-GPIO.
  MFD MAX8998/LP3974: Support Charger

 drivers/mfd/max8998-irq.c           |    7 +
 drivers/mfd/max8998.c               |  155 ++++++++++++++++++++-
 drivers/power/Kconfig               |    7 +
 drivers/power/Makefile              |    1 +
 drivers/power/max8998.c             |  265 +++++++++++++++++++++++++++++++++++
 drivers/regulator/max8998.c         |  223 ++++++++++++++++++++++++++---
 drivers/rtc/rtc-max8998.c           |   55 +++++++-
 include/linux/mfd/max8998-private.h |   15 ++-
 include/linux/mfd/max8998.h         |   42 +++++-
 9 files changed, 732 insertions(+), 38 deletions(-)
 create mode 100644 drivers/power/max8998.c

