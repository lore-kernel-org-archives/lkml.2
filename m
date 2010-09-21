Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0IUBTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:19:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0IUBTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HaoY4Qf8vNlsSuu1S8n3TxR54MJh4vS4zJjugowG6TPBcgkYCbSyYPBKR1JZIdcUyF
         nNbRv6lh0T6WIjMCCiosbphvWipHVcyRc12oyBNUJByRSpXZiDPJ5vLKfAI8dpaeWl0T
         XPs5rtXx5z56vEdkS4cOQl9BtUc+bWisGWpxY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/5] Staging: rtl8187se: r8180.h: fixed alot of checkpatch.pl issues
Date: Mon, 20 Sep 2010 21:19:38 -0400
Message-Id: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed numerous coding style issues

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_dm.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.h b/drivers/staging/rtl8187se/r8180_dm.h
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
1.7.3

