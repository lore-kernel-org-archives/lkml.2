Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HTVAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:00:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40675 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0HTVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=U5ZQ+3teCL7pRq6ZZyXgqQ1oW8fpUfKMmRcjysiwHAy9KuQSCtNViuxGUEODqmU45k
         5E7RCV6Vym+UWv/zyjH1kagwLWXzjM7kcuRp+R9r9jKzJq84M37Dh6Zl57aHYm3Y0e3J
         bbb3dh3MnJMQHbxmcapFcGOUTpLHbjsJrALU0=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 17:00:28 -0400
Message-ID: <AANLkTimhha-0OdSQgqvXPsq-ZfLE_kWdu_-N4U7HnBL1@mail.gmail.com>
Subject: [PATCH 4/8] Staging: rtl8187se: r8180_dm.h: fixed alot checkpatch.pl issues
From: T Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, bzolnier@gmail.com, Larry.Finger@lwfinger.net,
        joe@perches.com, pshah.mumbai@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 70dfb5566dca4997d5e886280d110715bcd787e5 Mon Sep 17 00:00:00 2001
From: Tracey Dent <Tdent48227@gmail.com>
Date: Fri, 20 Aug 2010 09:47:59 -0400
Subject: [PATCH 4/8] Staging: rtl8187se: r8180_dm.h: fixed alot
checkpatch.pl issues

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_dm.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.h
b/drivers/staging/rtl8187se/r8180_dm.h
index 84f4672..b775825 100644
--- a/drivers/staging/rtl8187se/r8180_dm.h
+++ b/drivers/staging/rtl8187se/r8180_dm.h
@@ -2,17 +2,17 @@
 #define R8180_DM_H

 #include "r8180.h"
-//#include "r8180_hw.h"
-//#include "r8180_93cx6.h"
+/* #include "r8180_hw.h"	*/
+/* #include "r8180_93cx6.h"	*/
 void SwAntennaDiversityRxOk8185(struct net_device *dev, u8 SignalStrength);
 bool SetAntenna8185(struct net_device *dev,	u8 u1bAntennaIndex);
-bool SwitchAntenna(	struct net_device *dev);
-void SwAntennaDiversity(struct net_device *dev	);
+bool SwitchAntenna(struct net_device *dev);
+void SwAntennaDiversity(struct net_device *dev);
 void SwAntennaDiversityTimerCallback(struct net_device *dev);
 bool CheckDig(struct net_device *dev);
 bool CheckHighPower(struct net_device *dev);
-void rtl8180_hw_dig_wq (struct work_struct *work);
-void rtl8180_tx_pw_wq (struct work_struct *work);
+void rtl8180_hw_dig_wq(struct work_struct *work);
+void rtl8180_tx_pw_wq(struct work_struct *work);
 void rtl8180_rate_adapter(struct work_struct * work);
 void TxPwrTracking87SE(struct net_device *dev);
 bool CheckTxPwrTracking(struct net_device *dev);
-- 
1.7.2.1
