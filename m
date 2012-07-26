Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2GZVnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:43:46 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:18020 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2GZVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:43:44 -0400
Date: Thu, 26 Jul 2012 23:43:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 2/5] staging: vt6656: Remove some redundant blank lines from
 hostap.c
In-Reply-To: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207262340120.14949@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch simply removes some completely redundant blank
lines from drivers/staging/vt6656/hostap.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/hostap.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index bc49611..126f578 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -49,7 +49,6 @@
 #define HOSTAP_CRYPT_ERR_TX_KEY_SET_FAILED 6
 #define HOSTAP_CRYPT_ERR_CARD_CONF_FAILED 7
 
-
 /*---------------------  Static Definitions -------------------------*/
 
 /*---------------------  Static Classes  ----------------------------*/
@@ -60,12 +59,8 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
 
-
-
-
 /*---------------------  Export Variables  --------------------------*/
 
-
 /*
  * Description:
  *      register net_device (AP) for hostap deamon
@@ -79,7 +74,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
  * Return Value:
  *
  */
-
 static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 {
     PSDevice apdev_priv;
@@ -122,7 +116,6 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 	       dev->name, pDevice->apdev->name);
 
     KeyvInitTable(pDevice,&pDevice->sKey);
-
 	return 0;
 }
 
@@ -139,10 +132,8 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
  * Return Value:
  *
  */
-
 static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
 {
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: disabling hostapd mode\n", pDevice->dev->name);
 
     if (pDevice->apdev && pDevice->apdev->name && pDevice->apdev->name[0]) {
@@ -158,11 +149,9 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
     pDevice->bEnable8021x = FALSE;
     pDevice->bEnableHostWEP = FALSE;
     pDevice->bEncryptionEnable = FALSE;
-
 	return 0;
 }
 
-
 /*
  * Description:
  *      Set enable/disable hostapd mode
@@ -176,7 +165,6 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
  * Return Value:
  *
  */
-
 int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
 {
 	if (val < 0 || val > 1)
@@ -193,7 +181,6 @@ int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
 		return hostap_disable_hostapd(pDevice, rtnl_locked);
 }
 
-
 /*
  * Description:
  *      remove station function supported for hostap deamon
@@ -212,7 +199,6 @@ static int hostap_remove_sta(PSDevice pDevice,
 {
 	unsigned int uNodeIndex;
 
-
     if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
         BSSvRemoveOneNode(pDevice, uNodeIndex);
     }
@@ -241,7 +227,6 @@ static int hostap_add_sta(PSDevice pDevice,
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 	unsigned int uNodeIndex;
 
-
     if (!BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
         BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
     }
@@ -294,7 +279,6 @@ static int hostap_add_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-
 static int hostap_get_info_sta(PSDevice pDevice,
 				       struct viawget_hostapd_param *param)
 {
@@ -341,7 +325,6 @@ static int hostap_reset_txexc_sta(PSDevice pDevice,
 	else {
 	    return -ENOENT;
 	}
-
 	return 0;
 }
 */
@@ -378,8 +361,6 @@ static int hostap_set_flags_sta(PSDevice pDevice,
 	return 0;
 }
 
-
-
 /*
  * Description:
  *      set generic element (wpa ie)
@@ -398,8 +379,6 @@ static int hostap_set_generic_element(PSDevice pDevice,
 {
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 
-
-
     memcpy( pMgmt->abyWPAIE,
             param->u.generic_elem.data,
             param->u.generic_elem.len
@@ -438,13 +417,11 @@ static int hostap_set_generic_element(PSDevice pDevice,
  * Return Value:
  *
  */
-
 static void hostap_flush_sta(PSDevice pDevice)
 {
     // reserved node index =0 for multicast node.
     BSSvClearNodeDBTable(pDevice, 1);
     pDevice->uAssocCount = 0;
-
     return;
 }
 
@@ -477,7 +454,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	BOOL    bKeyTableFull = FALSE;
 	WORD    wKeyCtl = 0;
 
-
 	param->u.crypt.err = 0;
 /*
 	if (param_len !=
@@ -489,7 +465,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	if (param->u.crypt.alg > WPA_ALG_CCMP)
 		return -EINVAL;
 
-
 	if ((param->u.crypt.idx > 3) || (param->u.crypt.key_len > MAX_KEY_LEN)) {
 		param->u.crypt.err = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " HOSTAP_CRYPT_ERR_KEY_SET_FAILED\n");
@@ -502,7 +477,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 		if (param->u.crypt.idx >= MAX_GROUP_KEY)
 			return -EINVAL;
         iNodeIndex = 0;
-
 	} else {
 	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == FALSE) {
 	        param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
@@ -557,7 +531,6 @@ static int hostap_set_encryption(PSDevice pDevice,
     }
 
 	if (param->u.crypt.alg == WPA_ALG_WEP) {
-
         if ((pDevice->bEnable8021x == FALSE) || (iNodeIndex == 0)) {
             KeybSetDefaultKey(  pDevice,
                                 &(pDevice->sKey),
@@ -567,7 +540,6 @@ static int hostap_set_encryption(PSDevice pDevice,
                                 abyKey,
                                 KEY_CTL_WEP
                              );
-
         } else {
             // 8021x enable, individual key
             dwKeyIndex |= (1 << 30); // set pairwise key
@@ -583,7 +555,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 
 
                 pMgmt->sNodeDBTable[iNodeIndex].bOnFly = TRUE;
-
             } else {
                 // Key Table Full
                 pMgmt->sNodeDBTable[iNodeIndex].bOnFly = FALSE;
@@ -638,7 +609,6 @@ static int hostap_set_encryption(PSDevice pDevice,
                            byKeyDecMode
                           );
        pMgmt->sNodeDBTable[iNodeIndex].bOnFly = TRUE;
-
     } else {
         dwKeyIndex |= (1 << 30); // set pairwise key
         if (KeybSetKey(pDevice,
@@ -689,12 +659,9 @@ static int hostap_set_encryption(PSDevice pDevice,
     pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = dwKeyIndex;
     pMgmt->sNodeDBTable[iNodeIndex].dwTSC47_16 = 0;
     pMgmt->sNodeDBTable[iNodeIndex].wTSC15_0 = 0;
-
 	return ret;
 }
 
-
-
 /*
  * Description:
  *      get each stations encryption key
@@ -717,7 +684,6 @@ static int hostap_get_encryption(PSDevice pDevice,
 	int     ii;
 	int     iNodeIndex =0;
 
-
 	param->u.crypt.err = 0;
 
 	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
@@ -736,11 +702,9 @@ static int hostap_get_encryption(PSDevice pDevice,
     for (ii = 0 ; ii < 8 ; ii++) {
         param->u.crypt.seq[ii] = (BYTE)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
     }
-
 	return ret;
 }
 
-
 /*
  * Description:
  *      vt6656_hostap_ioctl main function supported for hostap deamon.
@@ -754,7 +718,6 @@ static int hostap_get_encryption(PSDevice pDevice,
  * Return Value:
  *
  */
-
 int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
@@ -849,7 +812,6 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		goto out;
 	}
 
-
 	if ((ret == 0) && ap_ioctl) {
 		if (copy_to_user(p->pointer, param, p->length)) {
 			ret = -EFAULT;
@@ -859,7 +821,5 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 
  out:
 	kfree(param);
-
 	return ret;
 }
-
-- 
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

