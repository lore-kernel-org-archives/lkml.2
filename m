Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2KMIcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:32:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41564 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2KMI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:08 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/13] mfd: twl: Remove unused TWL_MODULE definitions
Date: Tue, 13 Nov 2012 09:28:47 +0100
Message-ID: <1352795334-7406-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AUDIO and MADC only available on twl4030 series and the TWL_MODULE_* mapping
is not needed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 9a5e284..7278c72 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -73,9 +73,7 @@
 #define TWL4030_MODULE_SECURED_REG	0x17
 
 #define TWL_MODULE_USB		TWL4030_MODULE_USB
-#define TWL_MODULE_AUDIO_VOICE	TWL4030_MODULE_AUDIO_VOICE
 #define TWL_MODULE_PIH		TWL4030_MODULE_PIH
-#define TWL_MODULE_MADC		TWL4030_MODULE_MADC
 #define TWL_MODULE_MAIN_CHARGE	TWL4030_MODULE_MAIN_CHARGE
 #define TWL_MODULE_PM_MASTER	TWL4030_MODULE_PM_MASTER
 #define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
-- 
1.8.0

