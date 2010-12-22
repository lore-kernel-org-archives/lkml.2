Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0LVGYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:24:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0LVGYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:24:11 -0500
Date: Wed, 22 Dec 2010 15:23:05 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/6] MFD MAX8998/LP3974 Driver Update
In-reply-to: <20101221155004.GA21871@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292998991-26968-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 22 Dec 2010 06:23:11.0561 (UTC)
 FILETIME=[B51D0B90:01CBA1A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update from the first revision named
"[PATCH] MFD MAX8998/LP3974: Add Features: hibernation, charger,
and other misc."
1. Seperated features
2. Added style fixes

MyungJoo Ham (6):
  MFD MAX8998/LP3974: Support Hibernation
  MFD MAX8998/LP3974: Support LP3974 RTC
  MFD MAX8998/LP3974 Bugfix: incorrect variable name (typo)
  MFD MAX8998/LP3974 Bufgix: accessing array out of bound.
  MFD MAX8998/LP3974: Charger Support
  MFD MAX8998/LP3974: Support DVS-GPIO.

 drivers/mfd/max8998-irq.c           |    7 +
 drivers/mfd/max8998.c               |  149 +++++++++++++++-
 drivers/regulator/max8998.c         |  334 ++++++++++++++++++++++++++++++++---
 drivers/rtc/rtc-max8998.c           |   55 ++++++-
 include/linux/mfd/max8998-private.h |    3 +
 include/linux/mfd/max8998.h         |   44 ++++-
 6 files changed, 556 insertions(+), 36 deletions(-)

