Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1LNJZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:25:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58413 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1LNJZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:25:07 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-5d-4ee86b7199cb
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH v2 0/2] leds: add MAX8997-LED driver
Date: Wed, 14 Dec 2011 18:23:54 +0900
Message-id: <1323854636-5295-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 integrates several features in a single chip.
It includes PMIC(Power Management IC), RTC, charger, fuel gauge, LED driver, and so on.
This patchset supports unimplemented LED driver of MAX8997.

These patches are available at:
git://git.infradead.org/users/kmpark/linux-samsung maxim-mfd

---
Changes for v2:
    - update confusing comment

Donggeun Kim (2):
  MFD: MAX8997: add platform data and devices for LED control
  leds: add suuport for MAX8997-LED driver

 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-max8997.c |  372 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/max8997.c       |    3 +-
 include/linux/mfd/max8997.h |   25 +++-
 5 files changed, 406 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-max8997.c

-- 
1.7.4.1

