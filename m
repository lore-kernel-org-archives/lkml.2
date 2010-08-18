Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab0HRGU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:20:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48446 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0HRGUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:20:41 -0400
From: felipe.balbi@nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 1/4] i2c: twl: add register defines for pm master module
Date: Wed, 18 Aug 2010 09:19:34 +0300
Message-Id: <1282112377-1335-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
In-Reply-To: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 18 Aug 2010 06:19:47.0532 (UTC) FILETIME=[5B7430C0:01CB3E9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

Some modules already need to talk to at least PROTECT_KEY
register, while at that, add defines to the entire register
space.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 include/linux/i2c/twl.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 6de90bf..a3bfbe1 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -357,6 +357,52 @@ int twl6030_interrupt_mask(u8 bit_mask, u8 offset);
 
 /*----------------------------------------------------------------------*/
 
+/*
+ * PM Master module register offsets (use TWL4030_MODULE_PM_MASTER)
+ */
+
+#define TWL4030_PM_MASTER_CFG_P1_TRANSITION	0x00
+#define TWL4030_PM_MASTER_CFG_P2_TRANSITION	0x01
+#define TWL4030_PM_MASTER_CFG_P3_TRANSITION	0x02
+#define TWL4030_PM_MASTER_CFG_P123_TRANSITION	0x03
+#define TWL4030_PM_MASTER_STS_BOOT		0x04
+#define TWL4030_PM_MASTER_CFG_BOOT		0x05
+#define TWL4030_PM_MASTER_SHUNDAN		0x06
+#define TWL4030_PM_MASTER_BOOT_BCI		0x07
+#define TWL4030_PM_MASTER_CFG_PWRANA1		0x08
+#define TWL4030_PM_MASTER_CFG_PWRANA2		0x09
+#define TWL4030_PM_MASTER_BACKUP_MISC_STS	0x0a
+#define TWL4030_PM_MASTER_BACKUP_MISC_CFG	0x0b
+#define TWL4030_PM_MASTER_BACKUP_MISC_TST	0x0c
+#define TWL4030_PM_MASTER_PROTECT_KEY		0x0d
+#define TWL4030_PM_MASTER_STS_HW_CONDITIONS	0x0e
+#define TWL4030_PM_MASTER_P1_SW_EVENTS		0x0f
+#define TWL4030_PM_MASTER_P2_SW_EVENTS		0x10
+#define TWL4030_PM_MASTER_P3_SW_EVENTS		0x11
+#define TWL4030_PM_MASTER_STS_P123_STATE	0x12
+#define TWL4030_PM_MASTER_PB_CFG		0x13
+#define TWL4030_PM_MASTER_PB_WORD_MSB		0x14
+#define TWL4030_PM_MASTER_PB_WORD_LSB		0x15
+#define TWL4030_PM_MASTER_SEQ_ADD_W2P		0x1b
+#define TWL4030_PM_MASTER_SEQ_ADD_P2A		0x1c
+#define TWL4030_PM_MASTER_SEQ_ADD_A2W		0x1d
+#define TWL4030_PM_MASTER_SEQ_ADD_A2S		0x1e
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A12		0x1f
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A3		0x20
+#define TWL4030_PM_MASTER_SEQ_ADD_WARM		0x21
+#define TWL4030_PM_MASTER_MEMORY_ADDRESS	0x22
+#define TWL4030_PM_MASTER_MEMORY_DATA		0x23
+
+#define TWL4030_PM_MASTER_KEY_CFG1		0xc0
+#define TWL4030_PM_MASTER_KEY_CFG2		0x0c
+
+#define TWL4030_PM_MASTER_KEY_TST1		0xe0
+#define TWL4030_PM_MASTER_KEY_TST2		0x0e
+
+#define TWL4030_PM_MASTER_GLOBAL_TST		0xb6
+
+/*----------------------------------------------------------------------*/
+
 /* Power bus message definitions */
 
 /* The TWL4030/5030 splits its power-management resources (the various
-- 
1.7.2.1.6.g61bf12

