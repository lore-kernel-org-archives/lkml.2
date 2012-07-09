Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2GICAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:00:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32971 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2GIB7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 21:59:45 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andriy.shevchenko@linux.intel.com, jj@chaosbits.net,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 3/5] staging: vt6656: hostap.c: Remove commented code
Date: Sun,  8 Jul 2012 22:55:48 -0300
Message-Id: <1341798950-11215-4-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341798950-11215-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/hostap.c |   43 ---------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index f578095..682002a 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -294,37 +294,6 @@ static int hostap_get_info_sta(PSDevice pDevice,
 	return 0;
 }
 
-/*
- * Description:
- *      reset txexec
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *      TURE, FALSE
- *
- * Return Value:
- *
- */
-/*
-static int hostap_reset_txexc_sta(PSDevice pDevice,
-					  struct viawget_hostapd_param *param)
-{
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-	unsigned int uNodeIndex;
-
-    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
-        pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts = 0;
-	}
-	else {
-	    return -ENOENT;
-	}
-
-	return 0;
-}
-*/
 
 /*
  * Description:
@@ -459,12 +428,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 
 
 	param->u.crypt.err = 0;
-/*
-	if (param_len !=
-	    (int) ((char *) param->u.crypt.key - (char *) param) +
-	    param->u.crypt.key_len)
-		return -EINVAL;
-*/
 
 	if (param->u.crypt.alg > WPA_ALG_CCMP)
 		return -EINVAL;
@@ -794,12 +757,6 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		 ret = hostap_get_info_sta(pDevice, param);
 		 ap_ioctl = 1;
 		break;
-/*
-	case VIAWGET_HOSTAPD_RESET_TXEXC_STA:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_RESET_TXEXC_STA \n");
-		 ret = hostap_reset_txexc_sta(pDevice, param);
-		break;
-*/
 	case VIAWGET_HOSTAPD_SET_FLAGS_STA:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA \n");
 		 ret = hostap_set_flags_sta(pDevice, param);
-- 
1.7.10.4

