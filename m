Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0HRHUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:20:32 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:43507 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0HRHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:20:27 -0400
Date: Wed, 18 Aug 2010 10:19:16 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] i2c: twl: add register defines for pm master module
Message-ID: <20100818071916.GF11947@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1282112377-1335-2-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Wed, Aug 18, 2010 at 08:19:34AM +0200, Balbi Felipe (Nokia-MS/Helsinki) wrote:
>From: Felipe Balbi <felipe.balbi@nokia.com>
>
>Some modules already need to talk to at least PROTECT_KEY
>register, while at that, add defines to the entire register
>space.
>
>Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
>---

here's updated patch with correct register space

8<--------------------------------------------------

 From a1021f7be2c7e277b303e6930285832f97258f85 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Thu, 1 Jul 2010 13:24:37 +0300
Subject: [PATCH 1/4] i2c: twl: add register defines for pm master module

Some modules already need to talk to at least PROTECT_KEY
register, while at that, add defines to the entire register
space.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
  include/linux/i2c/twl.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
  1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 6de90bf..9b17244 100644
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
+#define TWL4030_PM_MASTER_BACKUP_MISC_STS	0x0b
+#define TWL4030_PM_MASTER_BACKUP_MISC_CFG	0x0c
+#define TWL4030_PM_MASTER_BACKUP_MISC_TST	0x0d
+#define TWL4030_PM_MASTER_PROTECT_KEY		0x0e
+#define TWL4030_PM_MASTER_STS_HW_CONDITIONS	0x0f
+#define TWL4030_PM_MASTER_P1_SW_EVENTS		0x10
+#define TWL4030_PM_MASTER_P2_SW_EVENTS		0x11
+#define TWL4030_PM_MASTER_P3_SW_EVENTS		0x12
+#define TWL4030_PM_MASTER_STS_P123_STATE	0x13
+#define TWL4030_PM_MASTER_PB_CFG		0x14
+#define TWL4030_PM_MASTER_PB_WORD_MSB		0x15
+#define TWL4030_PM_MASTER_PB_WORD_LSB		0x16
+#define TWL4030_PM_MASTER_SEQ_ADD_W2P		0x1c
+#define TWL4030_PM_MASTER_SEQ_ADD_P2A		0x1d
+#define TWL4030_PM_MASTER_SEQ_ADD_A2W		0x1e
+#define TWL4030_PM_MASTER_SEQ_ADD_A2S		0x1f
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A12		0x20
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A3		0x21
+#define TWL4030_PM_MASTER_SEQ_ADD_WARM		0x22
+#define TWL4030_PM_MASTER_MEMORY_ADDRESS	0x23
+#define TWL4030_PM_MASTER_MEMORY_DATA		0x24
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

-- 
balbi

DefectiveByDesign.org
