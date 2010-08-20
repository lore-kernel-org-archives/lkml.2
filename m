Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0HTVAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:00:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51737 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0HTVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wbO7AIM862ZFIOYtTl5Uwtmf5ysxv8V6fkao5HLxTu2de1Pr8XkfZJpJoS1t58HpO7
         TjCRDzAxiq3KFLEdnyzEduTgT3kzVpngknebBiFm3BCgMqV1VR5e8Oegd7p8KuD8Hy06
         i1eD2KEDHOIzY8zZRRmL7hqCcxhLZ9F0OWwoY=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 17:00:36 -0400
Message-ID: <AANLkTik2PmKVOiyrOPvgM3jbsZzNUH+vJAa6afDObA3q@mail.gmail.com>
Subject: [PATCH 6/8] Staging: rtl8187se: r8180_rtl8225: fixed alot
 checkpatch.pl issues
From: T Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
        joe@perches.com, pshah.mumbai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1f445528c7fed22259e6bdc110a1d18ffb7f74a1 Mon Sep 17 00:00:00 2001
From: Tracey Dent <Tdent48227@gmail.com>
Date: Fri, 20 Aug 2010 10:41:50 -0400
Subject: [PATCH 6/8] Staging: rtl8187se: r8180_rtl8225: fixed alot
checkpatch.pl issues

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_rtl8225.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225.h
b/drivers/staging/rtl8187se/r8180_rtl8225.h
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
-bool SetZebraRFPowerState8185(struct net_device
*dev,RT_RF_POWER_STATE  eRFPowerState);
+void rtl8180_set_mode(struct net_device *dev, int mode);
+void rtl8180_set_mode(struct net_device *dev, int mode);
+bool SetZebraRFPowerState8185(struct net_device *dev,
RT_RF_POWER_STATE  eRFPowerState);
 void rtl8225z4_rf_sleep(struct net_device *dev);
 void rtl8225z4_rf_wakeup(struct net_device *dev);

-- 
1.7.2.1
