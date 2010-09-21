Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0IUBT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:19:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50358 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab0IUBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FFoA6RV/271UCRRPKvCrGGt6lWh0aBkuYsOUrJmnlUysnS8U/6dUX5Ej/Gx29ebmZR
         5JwRwEfT2MWl/WMR9oR48BLVIBIvwT7NWvp/ussjhuUF/RYd3hlRd31edL79beBv65a/
         eNLE/HDki6kyhtsyE2RdYZnkYkLBVkqUUVDWs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 3/5] Staging: rtl8187se: r8180_rtl8225: fixed a lot of checkpatch.pl issues
Date: Mon, 20 Sep 2010 21:19:40 -0400
Message-Id: <1285031982-3870-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_rtl8225.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225.h b/drivers/staging/rtl8187se/r8180_rtl8225.h
index ed35db5..494ea86 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225.h
+++ b/drivers/staging/rtl8187se/r8180_rtl8225.h
@@ -1,12 +1,12 @@
 /*
-  This is part of the rtl8180-sa2400 driver
-  released under the GPL (See file COPYING for details).
-  Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+	This is part of the rtl8180-sa2400 driver
+	released under the GPL (See file COPYING for details).
+	Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
 
-  This files contains programming code for the rtl8225
-  radio frontend.
+	This files contains programming code for the rtl8225
+	radio frontend.
 
-  *Many* thanks to Realtek Corp. for their great support!
+	*Many* thanks to Realtek Corp. for their great support!
 
 */
 
@@ -20,15 +20,15 @@
 #define RTL8225_ANAPARAM2_SLEEP 0x840dec11
 
 void rtl8225z2_rf_init(struct net_device *dev);
-void rtl8225z2_rf_set_chan(struct net_device *dev,short ch);
+void rtl8225z2_rf_set_chan(struct net_device *dev, short ch);
 void rtl8225z2_rf_close(struct net_device *dev);
 
 void RF_WriteReg(struct net_device *dev, u8 offset, u32	data);
 u32 RF_ReadReg(struct net_device *dev, u8 offset);
 
-void rtl8180_set_mode(struct net_device *dev,int mode);
-void rtl8180_set_mode(struct net_device *dev,int mode);
-bool SetZebraRFPowerState8185(struct net_device *dev,RT_RF_POWER_STATE  eRFPowerState);
+void rtl8180_set_mode(struct net_device *dev, int mode);
+void rtl8180_set_mode(struct net_device *dev, int mode);
+bool SetZebraRFPowerState8185(struct net_device *dev, RT_RF_POWER_STATE  eRFPowerState);
 void rtl8225z4_rf_sleep(struct net_device *dev);
 void rtl8225z4_rf_wakeup(struct net_device *dev);
 
-- 
1.7.3

