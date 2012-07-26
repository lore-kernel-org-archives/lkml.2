Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2GZVo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:44:29 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:42491 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GZVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:44:25 -0400
Date: Thu, 26 Jul 2012 23:44:24 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 4/5] staging: vt6656: minor trivial whitespace cleanups
In-Reply-To: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207262341220.14949@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a few tabs to spaces, remove some pointless whitespace, add
some missing whitespace (in drivers/staging/vt6656/hostap.c).
All quite small and trivial.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/hostap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index bb2c3d0..1f7a860 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -55,7 +55,7 @@
 
 /*---------------------  Static Variables  --------------------------*/
 //static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
 
@@ -115,7 +115,7 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdevice %s for AP management\n",
 		dev->name, pDevice->apdev->name);
 
-	KeyvInitTable(pDevice,&pDevice->sKey);
+	KeyvInitTable(pDevice, &pDevice->sKey);
 	return 0;
 }
 
@@ -257,8 +257,7 @@ static int hostap_add_sta(PSDevice pDevice,
 		param->sta_addr[2],
 		param->sta_addr[3],
 		param->sta_addr[4],
-		param->sta_addr[5]
-		);
+		param->sta_addr[5]);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Max Support rate = %d \n",
 		pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
 	return 0;
@@ -347,7 +346,7 @@ static int hostap_set_flags_sta(PSDevice pDevice,
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags |= param->u.set_flags_sta.flags_or;
 		pMgmt->sNodeDBTable[uNodeIndex].dwFlags &= param->u.set_flags_sta.flags_and;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " dwFlags = %x\n",
-			(unsigned int) pMgmt->sNodeDBTable[uNodeIndex].dwFlags);
+			(unsigned int)pMgmt->sNodeDBTable[uNodeIndex].dwFlags);
 	} else {
 		return -ENOENT;
 	}
@@ -377,7 +376,7 @@ static int hostap_set_generic_element(PSDevice pDevice,
 
 	pMgmt->wWPAIELen = param->u.generic_elem.len;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pMgmt->wWPAIELen = %d\n", pMgmt->wWPAIELen);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->wWPAIELen = %d\n", pMgmt->wWPAIELen);
 
 	// disable wpa
 	if (pMgmt->wWPAIELen == 0) {
-- 
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

