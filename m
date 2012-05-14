Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2ENFU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:20:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48966 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2ENFU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:20:28 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-5c-4fb0961a0372
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v3 0/2] MAX77693: add initial MAX77693 MFD driver
Date: Mon, 14 May 2012 14:20:17 +0900
Message-id: <1336972817-15135-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77693 is sub PMIC(Power Management IC) working with other main PMIC.
It has several features:
-PMIC
-MUIC(Micro USB Interface Controller)
-Camera flash LED control
-Haptic motor control

This patch adds initial basis for several devices. It is tested on TRATS board.

v3
- Add support irq domain for MAXIM77686 interrupts
- Apply regmap for i2c

v2
- with comments from Mark
- use devm_kzalloc rather than kzalloc
- print device ID read from device

Chanwoo Choi (2):
  MFD: MAX77693: add MAX77693 MFD driver
  MFD: MAX77693: add IRQ handler

 drivers/mfd/Kconfig                  |   12 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77693-irq.c           |  319 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |  254 +++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  217 +++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   37 ++++
 6 files changed, 840 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h

