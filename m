Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1CDGua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:50:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1CDGu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:50:29 -0500
Date: Fri, 04 Mar 2011 15:50:25 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/2] MAX8997/8966 MFD (includig PMIC) Initial Release
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 04 Mar 2011 06:50:28.0026 (UTC)
 FILETIME=[7243C9A0:01CBDA38]
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

In this initial release, PMIC (as set of regulators) is included.

The changes from previous patch
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

MyungJoo Ham (2):
  MAX8997/8966 MFD Driver Initial Release (PMIC+RTC+MUIC+Haptic+...)
  MAX8997/8966 PMIC Regulator Driver Initial Release

 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8997.c               |  427 ++++++++++++
 drivers/regulator/Kconfig           |    9 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/max8997.c         | 1238 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |  347 ++++++++++
 include/linux/mfd/max8997.h         |  114 ++++
 8 files changed, 2149 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 drivers/regulator/max8997.c
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h

