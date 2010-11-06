Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KFQYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:24:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46788 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab0KFQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xPiCwH39HbzTefhfHoEMSt4RFKd4klISPUaKINyOPefnD5Zh/AwLaY+67EgW0a3z0W
         TVkyutMbKn8o1XydC/neT9VMARzhtnEGLSnzFyfeQVh47N3oqXmKsHKP8exBwVXK+bSH
         4DVyZqa2z2ItXz9jwJJnZ/9dTZi2woQMl4yA8=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] Staging: wlan-ng: fix coding style issues in prism2mgmt.c
Date: Sat,  6 Nov 2010 18:23:44 +0200
Message-Id: <1289060625-13872-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to prism2mgmt.c that fixes coding style issues found by checkpatch.pl. Three instances of the 80 char line limit being exceeded have been kept as is so that string literals are not split up.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/prism2mgmt.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 04514a8..6675c82 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -213,8 +213,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 		u16 wordbuf[17];
 
 		result = hfa384x_drvr_setconfig16(hw,
-						  HFA384x_RID_CNFROAMINGMODE,
-						  HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM);
+					HFA384x_RID_CNFROAMINGMODE,
+					HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM);
 		if (result) {
 			printk(KERN_ERR
 			       "setconfig(ROAMINGMODE) failed. result=%d\n",
@@ -258,8 +258,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 		}
 		/* ibss options */
 		result = hfa384x_drvr_setconfig16(hw,
-						  HFA384x_RID_CREATEIBSS,
-						  HFA384x_CREATEIBSS_JOINCREATEIBSS);
+					HFA384x_RID_CREATEIBSS,
+					HFA384x_CREATEIBSS_JOINCREATEIBSS);
 		if (result) {
 			printk(KERN_ERR "Failed to set CREATEIBSS.\n");
 			msg->resultcode.data =
@@ -416,7 +416,8 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 #define REQBASICRATE(N) \
 	if ((count >= N) && DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
 		req->basicrate ## N .data = item->supprates[(N)-1]; \
-		req->basicrate ## N .status = P80211ENUM_msgitem_status_data_ok; \
+		req->basicrate ## N .status = \
+			P80211ENUM_msgitem_status_data_ok; \
 	}
 
 	REQBASICRATE(1);
@@ -431,7 +432,8 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 #define REQSUPPRATE(N) \
 	if (count >= N) { \
 		req->supprate ## N .data = item->supprates[(N)-1]; \
-		req->supprate ## N .status = P80211ENUM_msgitem_status_data_ok; \
+		req->supprate ## N .status = \
+			P80211ENUM_msgitem_status_data_ok; \
 	}
 
 	REQSUPPRATE(1);
@@ -1102,7 +1104,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 		result = hfa384x_drvr_disable(hw, 0);
 		if (result) {
 			pr_debug
-			    ("failed to disable port 0 after sniffing, result=%d\n",
+			("failed to disable port 0 after sniffing, result=%d\n",
 			     result);
 			goto failed;
 		}
@@ -1137,7 +1139,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 			result = hfa384x_drvr_enable(hw, 0);
 			if (result) {
 				pr_debug
-				    ("failed to enable port to presniff setting, result=%d\n",
+				("failed to enable port to presniff setting, result=%d\n",
 				     result);
 				goto failed;
 			}
@@ -1161,7 +1163,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 						  &(hw->presniff_port_type));
 				if (result) {
 					pr_debug
-					    ("failed to read porttype, result=%d\n",
+					("failed to read porttype, result=%d\n",
 					     result);
 					goto failed;
 				}
@@ -1171,7 +1173,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 						  &(hw->presniff_wepflags));
 				if (result) {
 					pr_debug
-					    ("failed to read wepflags, result=%d\n",
+					("failed to read wepflags, result=%d\n",
 					     result);
 					goto failed;
 				}
@@ -1238,8 +1240,8 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 
 			if (result) {
 				pr_debug
-				    ("failed to set wepflags=0x%04x, result=%d\n",
-				     word, result);
+				  ("failed to set wepflags=0x%04x, result=%d\n",
+				   word, result);
 				goto failed;
 			}
 		}
-- 
1.7.1

