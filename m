Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab0FQIqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:46:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53508 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0FQIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aUborSo/W5InJ985hEjAlAgbcsv2swpQIe3a0v1HE62BDtOqnZToiNjYDtw9amEM1/
         BJMarWZr2ZvNhzMbG8+nM4HUFZDN2D4Y8+wnsOZeeafrnUPCOvQlDk25w6r5l5/c2q7M
         nSPsss5zHL0Jn/u18flLjx3cknIVxaGPaBRIg=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, horms@verge.net.au, dcb314@hotmail.com, sharms@ubuntu.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Matti Lammi <mattij.lammi@gmail.com>
Subject: [PATCH] Drivers: Staging: Fixed several checkpatch.pl issues
Date: Thu, 17 Jun 2010 11:46:27 +0300
Message-Id: <1276764387-14791-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved braces and removed some unnecessary spaces. Just small fixes.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/otus/ioctl.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index a48c8e4..adf3f14 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -63,0 +63,0 @@

 extern u16_t zfLnxGetVapId(zdev_t *dev);

-static const u32_t channel_frequency_11A[] =
-{
+static const u32_t channel_frequency_11A[] = {
 	/* Even element for Channel Number, Odd for Frequency */
 	36, 5180,
 	40, 5200,
@@ -1361,1 +1360,1 @@ int usbdrvwext_giwpower(struct net_device *dev,
 }

 /*int usbdrvwext_setparam(struct net_device *dev, struct iw_request_info *info,
-*		   	 void *w, char *extra)
+*			void *w, char *extra)
 *{
 *	struct ieee80211vap *vap = dev->ml_priv;
 *	struct ieee80211com *ic = vap->iv_ic;
@@ -2261,1 +2260,1 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		printk(KERN_ERR "wd->ap.wpaLen : % d\n", len);

 		/* DUMP WPA IE */
-		for(ii = 0; ii < len;) {
+		for (ii = 0; ii < len;) {
 			printk(KERN_ERR "0x%02x ", wpaie[ii]);

-			if((++ii % 16) == 0)
+			if ((++ii % 16) == 0)
 				printk(KERN_ERR "\n");
 		}
 		printk(KERN_ERR "\n");
@@ -2309,2 +2308,2 @@ int usbdrv_cenc_ioctl(struct net_device *dev, struct zydas_cenc_param *zdparm)
 	/* Get the AP Id */
 	apId = zfLnxGetVapId(dev);

-	if (apId == 0xffff) {
+	if (apId == 0xffff)
 		apId = 0;
-	} else {
+	else
 		apId = apId + 1;
-	}

 	switch (zdparm->cmd) {
 	case ZM_CMD_CENC_SETCENC:
@@ -2334,0 +2332,0 @@ int usbdrv_cenc_ioctl(struct net_device *dev, struct zydas_cenc_param *zdparm)

 		printk(KERN_ERR "Key Index : % d\n", zdparm->u.crypt.keyid);
 		printk(KERN_ERR "Encryption key = ");
-		for (ii = 0; ii < 16; ii++) {
+		for (ii = 0; ii < 16; ii++)
 			printk(KERN_ERR "0x%02x ", zdparm->u.crypt.key[ii]);
-		}
 		printk(KERN_ERR "\n");

 		printk(KERN_ERR "MIC key = ");
-		for(ii = 16; ii < ZM_CENC_KEY_SIZE; ii++) {
+		for (ii = 16; ii < ZM_CENC_KEY_SIZE; ii++)
 			printk(KERN_ERR "0x%02x ", zdparm->u.crypt.key[ii]);
-		}
 		printk(KERN_ERR "\n");

 		/* Set up key information */
@@ -2424,7 +2420,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	case SIOCSIWRTS:
 		err = usbdrv_ioctl_setrts(dev, &wrq->u.rts);
-		if (! err)
+		if (!err)
 			changed = 1;
 		break;
 	/* set_auth */
@@ -2618,7 +2614,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				zfiWlanSetWepStatus(dev, ZM_ENCRYPTION_AES);
 				}
 			}
-			//WPA2 or WPA2PSK
+			/*WPA2 or WPA2PSK*/
 			if ((macp->supIe[17] == 0xf) ||
 				(macp->supIe[18] == 0xac)) {
 				if (macp->supIe[13] == 0x2) {
@@ -2656,2 +2652,2 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			printk(KERN_ERR
 				"****************ZD_PARAM_COUNTERMEASURES : ");

-			if(arg) {
+			if (arg) {
 				/*    mCounterMeasureState=1; */
 				printk(KERN_ERR "enable\n");
 			} else {
@@ -2667,2 +2663,2 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (op == ZD_PARAM_DROPUNENCRYPTED) {
 			printk(KERN_ERR "ZD_PARAM_DROPUNENCRYPTED : ");

-			if(arg) {
+			if (arg)
 				printk(KERN_ERR "enable\n");
-			} else {
+			else
 				printk(KERN_ERR "disable\n");
-			}
 		}
 		if (op == ZD_PARAM_AUTH_ALGS) {
 			printk(KERN_ERR "ZD_PARAM_AUTH_ALGS : ");

-			if (arg == 0) {
+			if (arg == 0)
 				printk(KERN_ERR "OPEN_SYSTEM\n");
-			} else {
+			else
 				printk(KERN_ERR "SHARED_KEY\n");
-			}
 		}
 		if (op == ZD_PARAM_WPS_FILTER) {
 			printk(KERN_ERR "ZD_PARAM_WPS_FILTER : ");
@@ -2705,2 +2699,2 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		/* Get the AP Id */
 		apId = zfLnxGetVapId(dev);

-		if (apId == 0xffff) {
+		if (apId == 0xffff)
 			apId = 0;
-		} else {
+		else
 			apId = apId + 1;
-		}

 		if (copy_from_user(&req_wpaie, ifr->ifr_data,
 					sizeof(struct ieee80211req_wpaie))) {
--
1.6.0.4

