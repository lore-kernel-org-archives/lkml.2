Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1IBPDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:03:40 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40412 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab1IBPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:03:37 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] MFD/Input: twl6040 (vibra): cleanups
Date: Fri,  2 Sep 2011 18:03:01 +0300
Message-Id: <1314975785-25081-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Small cleanups for the twl6040 MFD driver:
removing the global pointer for the platform_device,
adding accessor to fetch the revision ID of the IC,
Fixing the audpwron GPIO handling.

Changes since v1:
- Accessor for revision is used in the core driver
- audpwron GPIO handling fix

Peter
---
Peter Ujfalusi (4):
  MFD: twl6040: Remove global pointer for platform_device
  MFD: twl6040: Add accessor for revision ID
  Input: twl6040-vibra: Use accessor to get revision information
  MFD: twl6040: Fix power on GPIO handling

 drivers/input/misc/twl6040-vibra.c |    2 +-
 drivers/mfd/twl6040-core.c         |   38 ++++++++++++++++-------------------
 include/linux/mfd/twl6040.h        |    5 ++++
 3 files changed, 23 insertions(+), 22 deletions(-)

-- 
1.7.6.1

