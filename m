Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LIJPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:15:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9242 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1LIJPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:15:45 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-3f-4ee1d1c09a66
From: Donggeun Kim <dg77.kim@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] MFD: MAX77693: add initial MAX77693 MFD driver
Date: Fri, 09 Dec 2011 18:15:38 +0900
Message-id: <1323422140-31332-1-git-send-email-dg77.kim@samsung.com>
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

Donggeun Kim (2):
  MFD: MAX77693: add MAX77693 MFD driver
  MFD: MAX77693: add IRQ handler

 drivers/mfd/Kconfig                  |   12 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77693-irq.c           |  307 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |  256 ++++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  221 ++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   38 ++++
 6 files changed, 835 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h

-- 
1.7.4.1

