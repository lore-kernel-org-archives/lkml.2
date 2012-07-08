Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2GHW7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:59:32 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27086 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:59:31 -0400
Date: Mon, 9 Jul 2012 00:59:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: vt6656: iwctl: remove a few remaining redundant
 newlines
In-Reply-To: <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207090056180.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net> <20120706230945.GA8835@kroah.com> <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net> <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed a few redundant newlines the first time.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 13ad62c..8b9894b 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -964,7 +964,6 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
-
 	return 0;
 }
 
@@ -1003,7 +1002,6 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
-
 	return 0;
 }
 
@@ -1097,7 +1095,6 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 
 	// Send the key to the card
 	if (wrq->length > 0) {
-
 		if (wrq->length == WLAN_WEP232_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
 		} else if (wrq->length == WLAN_WEP104_KEYLEN) {
@@ -1119,8 +1116,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 					dwKeyIndex | (1 << 31),
 					wrq->length, NULL,
 					pDevice->abyKey,
-					KEY_CTL_WEP
-				);
+					KEY_CTL_WEP);
 			spin_unlock_irq(&pDevice->lock);
 		}
 		pDevice->byKeyIndex = (BYTE)dwKeyIndex;
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

