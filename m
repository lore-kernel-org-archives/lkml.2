Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2DZSrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:47:45 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:31178 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2DZSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQV5EFE8GwcSiBG6eJBlBJV9kECCag
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960570"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 2/7] staging: sm7xx: dead code removal
Date: Thu, 26 Apr 2012 20:45:50 +0200
Message-Id: <1335465955-32057-3-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove dead code.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |    8 --------
 drivers/staging/sm7xx/smtcfb.h |    6 ------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 39ba558..abed491 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -105,14 +105,6 @@ char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 static u32 colreg[17];
 static struct par_info hw;	/* hardware information */
 
-u16 smtc_ChipIDs[] = {
-	0x710,
-	0x712,
-	0x720
-};
-
-#define numSMTCchipIDs ARRAY_SIZE(smtc_ChipIDs)
-
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
 	.yres           = 600,
diff --git a/drivers/staging/sm7xx/smtcfb.h b/drivers/staging/sm7xx/smtcfb.h
index ab95af2..70283a1 100644
--- a/drivers/staging/sm7xx/smtcfb.h
+++ b/drivers/staging/sm7xx/smtcfb.h
@@ -20,12 +20,6 @@
 
 #define FB_ACCEL_SMI_LYNX 88
 
-#ifdef __BIG_ENDIAN
-#define PC_VGA            0
-#else
-#define PC_VGA            1
-#endif
-
 #define SCREEN_X_RES      1024
 #define SCREEN_Y_RES      600
 #define SCREEN_BPP        16
-- 
1.7.2.5

