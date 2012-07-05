Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2GEOqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:46:23 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34422 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932288Ab2GEOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMPAUYQJQImAgJXBxKID6Z6klaBII9FgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562632"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 02/19] Staging: xgifb: Remove unneeded XGI_LCD_TYPE enumeration.
Date: Thu,  5 Jul 2012 16:45:45 +0200
Message-Id: <92929fc9e127b605075fe1d026a9807dab1d3ae9.1341498465.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LCD_TYPEs are taken from drivers/video/sis/sis.h, so this enumeration is not
needed.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vgatypes.h |   34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 839acb40..cfd421c 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -21,40 +21,6 @@ enum XGI_VB_CHIP_TYPE {
 };
 #endif
 
-
-#define XGI_LCD_TYPE
-/* Since the merge with video/sis the LCD_TYPEs are used from
- drivers/video/sis/sis.h . Nevertheless we keep this (for the moment) for
- future reference until the code is merged completely and we are sure
- nothing of this should be added to the sis.h header */
-#ifndef XGI_LCD_TYPE
-enum XGI_LCD_TYPE {
-	LCD_INVALID = 0,
-	LCD_320x480,       /* FSTN, DSTN */
-	LCD_640x480,
-	LCD_640x480_2,     /* FSTN, DSTN */
-	LCD_640x480_3,     /* FSTN, DSTN */
-	LCD_800x600,
-	LCD_848x480,
-	LCD_1024x600,
-	LCD_1024x768,
-	LCD_1152x768,
-	LCD_1152x864,
-	LCD_1280x720,
-	LCD_1280x768,
-	LCD_1280x800,
-	LCD_1280x960,
-	LCD_1280x1024,
-	LCD_1400x1050,
-	LCD_1600x1200,
-	LCD_1680x1050,
-	LCD_1920x1440,
-	LCD_2048x1536,
-	LCD_CUSTOM,
-	LCD_UNKNOWN
-};
-#endif
-
 struct xgi_hw_device_info {
 	unsigned long ulExternalChip; /* NO VB or other video bridge*/
 				      /* if ujVBChipID = VB_CHIP_UNKNOWN, */
-- 
1.7.9.5

