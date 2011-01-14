Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1ANG4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:56:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21108 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1ANG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:56:32 -0500
Date: Fri, 14 Jan 2011 15:53:36 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 0/2] MAX8997/8966 MFD (PMIC+RTC+...) Initial Release
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1294988018-25100-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 14 Jan 2011 06:53:39.0123 (UTC)
 FILETIME=[C5ED2030:01CBB3B7]
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

MyungJoo Ham (2):
  MAX8997/8966 MFD Driver Initial Release (PMIC+RTC+MUIC+Haptic+...)
  MAX8997/8966 PMIC Regulator Driver Initial Release

 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8997.c               |  211 +++++++++
 drivers/regulator/Kconfig           |    9 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/max8997.c         |  867 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |  238 ++++++++++
 include/linux/mfd/max8997.h         |  106 +++++
 8 files changed, 1445 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 drivers/regulator/max8997.c
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h

