Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1LLKjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:39:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22553 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1LLKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:39:20 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-fb-4ee5d9d64bbe
From: Donggeun Kim <dg77.kim@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] MFD: MAX77693: add initial MAX77693 MFD driver
Date: Mon, 12 Dec 2011 19:39:09 +0900
Message-id: <1323686351-24907-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77693 is sub PMIC(Power Management IC) working with other main PMIC.
It has several features:
-PMIC
-MUIC(Micro USB Interface Controller)
-Camera flash LED control
-Haptic motor control

This patch adds initial basis for several devices.
---
Changes for v2:
    - with comments from Mark
	- use devm_kzalloc rather than kzalloc
	- print device ID read from device

Donggeun Kim (2):
  MFD: MAX77693: add MAX77693 MFD driver
  MFD: MAX77693: add IRQ handler

 drivers/mfd/Kconfig                  |   12 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77693-irq.c           |  307 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |  255 ++++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  221 ++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   38 ++++
 6 files changed, 834 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h

-- 
1.7.4.1

