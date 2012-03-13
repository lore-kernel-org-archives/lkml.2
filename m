Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2CMF2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:28:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35083 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2CMF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:28:33 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-46-4f5edb00f466
Message-id: <4F5EDB00.2040405@samsung.com>
Date: Tue, 13 Mar 2012 14:28:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: [RESEND PATCH v2 0/2] MAX77693: add initial MAX77693 MFD driver
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
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
 drivers/mfd/max77693-irq.c           |  307
++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |  256 ++++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  221 ++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   38 ++++
 6 files changed, 835 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h
