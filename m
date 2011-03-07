Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1CGLK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:10:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52484 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1CGLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:10:58 -0500
Date: Mon, 07 Mar 2011 19:27:27 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v3 0/4] MAX8997/8966 MFD (including PMIC&RTC) Initial Release
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1299493651-25832-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 07 Mar 2011 10:27:32.0079 (UTC)
 FILETIME=[4471CFF0:01CBDCB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997/8966 has
- PMIC
- RTC
- MUIC (usb switch)
- Flash control
- Haptic control
- Fuel Gauge (MAX17042 compatible)
- Battery charger control

This patch adds an initial driver for Maxim Semiconductor 8997/8966's
PMIC function.

In this initial release, PMIC (as set of regulators) and RTC drivers are
included.

The changes from previous patch
v3
with comments from Joe:
	- Style updated for IRQ and RTC
with comments from Mark
	- Style updated for RTC and PMIC
Merged support for RTC and IRQ

v2
with comments from Samuel:
	- Style updated for MFD
with comments from Mark:
	- Updated API for next and 2.6.38
	- Style updated for regulators
Support for hibernation
Support for bulk register access
Corrected register names
Added RTC/IRQ registers
LDO access bug fixed
Support for regulator suspend state control

MyungJoo Ham (4):
  MAX8997/8966 MFD Driver Initial Release (PMIC+RTC+MUIC+Haptic+...)
  MAX8997/8966 PMIC Regulator Driver Initial Release
  MAX8997/8966 MFD: Add IRQ control feature
  MAX8997/8966 RTC Driver Initial Release

 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8997-irq.c           |  337 ++++++++++
 drivers/mfd/max8997.c               |  427 +++++++++++++
 drivers/regulator/Kconfig           |    9 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/max8997.c         | 1196 +++++++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig                 |   10 +
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-max8997.c           |  445 +++++++++++++
 include/linux/mfd/max8997-private.h |  359 +++++++++++
 include/linux/mfd/max8997.h         |  120 ++++
 12 files changed, 2918 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8997-irq.c
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 drivers/regulator/max8997.c
 create mode 100644 drivers/rtc/rtc-max8997.c
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h

