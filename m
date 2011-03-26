Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab1CZBok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46852 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932136Ab1CZBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:34 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18PxCt/lK0PbHf6O30vW07DyxkT1nfuuphnXBMZSC
	7A2jk3n74pibm+
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 16/27] staging/rt2860: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:00 +0100
Message-Id: <1301103851-16352-16-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/rt2860.

WRONG -> RIGHT
reqest		-> request
requst		-> request
recieve     -> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rt2860/common/action.c       |    2 +-
 drivers/staging/rt2860/common/ba_action.c    |    4 ++--
 drivers/staging/rt2860/common/cmm_data_usb.c |    2 +-
 drivers/staging/rt2860/sta/connect.c         |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rt2860/common/action.c b/drivers/staging/rt2860/common/action.c
index 56ad236..2f21e66 100644
--- a/drivers/staging/rt2860/common/action.c
+++ b/drivers/staging/rt2860/common/action.c
@@ -456,7 +456,7 @@ void PeerHTAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 62f6f6b..8ce7e16 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -970,7 +970,7 @@ void BASessionTearDownALL(struct rt_rtmp_adapter *pAd, u8 Wcid)
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
@@ -1032,7 +1032,7 @@ void BAOriSessionSetupTimeout(void *SystemSpecific1,
 /*
 	==========================================================================
 	Description:
-		Retry sending ADDBA Reqest.
+		Retry sending ADDBA Request.
 
 	IRQL = DISPATCH_LEVEL
 
diff --git a/drivers/staging/rt2860/common/cmm_data_usb.c b/drivers/staging/rt2860/common/cmm_data_usb.c
index 7c56c2f..b0de809 100644
--- a/drivers/staging/rt2860/common/cmm_data_usb.c
+++ b/drivers/staging/rt2860/common/cmm_data_usb.c
@@ -702,7 +702,7 @@ Arguments:
 	*pRxPending			pending received packet flag
 
 Return Value:
-    the recieved packet
+    the received packet
 
 Note:
 ========================================================================
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index 4996258..f4f3caa 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -1852,7 +1852,7 @@ void LinkUp(struct rt_rtmp_adapter *pAd, u8 BssType)
 	IRQL = DISPATCH_LEVEL
 
 	Note:
-		We need more information to know it's this requst from AP.
+		We need more information to know it's this request from AP.
 		If yes! we need to do extra handling, for example, remove the WPA key.
 		Otherwise on 4-way handshaking will fail, since the WPA key didn't get
 		removed while auto reconnect.
-- 
1.7.3.4

