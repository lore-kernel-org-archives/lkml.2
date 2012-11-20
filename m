Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2KTMKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:10:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53318 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2KTMKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:10:02 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 01/16] staging/rtl8187se: Fix spacing coding style in r8180_dm.h
Date: Tue, 20 Nov 2012 21:09:55 +0900
Message-Id: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
-ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8180_dm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_dm.h b/drivers/staging/rtl8187se/r8180_dm.h
index b775825..732c06a 100644
--- a/drivers/staging/rtl8187se/r8180_dm.h
+++ b/drivers/staging/rtl8187se/r8180_dm.h
@@ -13,10 +13,10 @@ bool CheckDig(struct net_device *dev);
 bool CheckHighPower(struct net_device *dev);
 void rtl8180_hw_dig_wq(struct work_struct *work);
 void rtl8180_tx_pw_wq(struct work_struct *work);
-void rtl8180_rate_adapter(struct work_struct * work);
+void rtl8180_rate_adapter(struct work_struct *work);
 void TxPwrTracking87SE(struct net_device *dev);
 bool CheckTxPwrTracking(struct net_device *dev);
-void rtl8180_rate_adapter(struct work_struct * work);
+void rtl8180_rate_adapter(struct work_struct *work);
 void timer_rate_adaptive(unsigned long data);
 
 
-- 
1.7.9.5

