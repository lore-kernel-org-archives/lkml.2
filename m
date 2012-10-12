Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab2JLQh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:37:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821Ab2JLQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:37:55 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 2/9] Staging: winbond: phy_calibration: Fixed coding style issue
Date: Fri, 12 Oct 2012 22:07:08 +0530
Message-Id: <1350059835-5408-3-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed checkpatch.pl script reported ERRORs

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 .../drivers/staging/winbond/phy_calibration.c      |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c b/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c
index 77a3fff..b881980 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c
@@ -22,7 +22,7 @@
 #define LOOP_TIMES      20
 #define US              1000/* MICROSECOND*/
 
-#define AG_CONST        0.6072529350
+#define AG_CONST        (0.6072529350)
 #define FIXED(X)        ((s32)((X) * 32768.0))
 #define DEG2RAD(X)      (0.017453 * (X))
 
@@ -296,7 +296,7 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 	}
 }
 
-static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 * pValue)
+static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 *pValue)
 {
 	if (number < 0x1000)
 		number += 0x1000;
-- 
1.7.7.3

