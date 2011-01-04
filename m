Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1ADFYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:24:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1ADFYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:24:31 -0500
Date: Tue, 04 Jan 2011 14:17:38 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v4 0/3] MFD MAX8998/LP3974 Driver Update
In-reply-to: <20101224113805.GI27832@sortiz-mobl>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1294118261-18906-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101224113805.GI27832@sortiz-mobl>
X-OriginalArrivalTime: 04 Jan 2011 05:17:41.0812 (UTC)
 FILETIME=[B62BAF40:01CBABCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update at v4
1. Removed "MFD MAX8998/LP3974: Support Hibernation" as this patch
is already applied.
2. "MFD MAX8998/LP3974: Support LP3974 RTC": RTC register delay chip bug
information is included at platform data, not at the device id.
Note that the other two patches remain the same and the ACK from the
previous patch release is attached.

update at v3
1. Removed independant bugfixes from the patch set.
2. Power Supply API supported.
3. Removed regulators that became useless by introducing Power Supply API.

update at v2
1. Seperated features
2. Added style fixes

v1: "[PATCH] MFD MAX8998/LP3974: Add Features: hibernation, charger,
and other misc."

MyungJoo Ham (3):
  MFD MAX8998/LP3974: Support LP3974 RTC
  regulator MAX8998/LP3974: Support DVS-GPIO.
  MFD MAX8998/LP3974: Support Charger

 drivers/mfd/max8998.c               |   30 ++++-
 drivers/power/Kconfig               |    7 +
 drivers/power/Makefile              |    1 +
 drivers/power/max8998.c             |  265 +++++++++++++++++++++++++++++++++++
 drivers/regulator/max8998.c         |  223 ++++++++++++++++++++++++++---
 drivers/rtc/rtc-max8998.c           |   54 +++++++-
 include/linux/mfd/max8998-private.h |   12 ++-
 include/linux/mfd/max8998.h         |   45 +++++-
 8 files changed, 599 insertions(+), 38 deletions(-)
 create mode 100644 drivers/power/max8998.c

