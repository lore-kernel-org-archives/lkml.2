Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649Ab2CNW3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:29:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43716 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761600Ab2CNW3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:29:07 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 2/3] Staging: rtl8187se: r8180_core.c: Fix some spacing issues
Date: Wed, 14 Mar 2012 18:26:58 -0400
Message-Id: <1331764019-5808-3-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331764019-5808-1-git-send-email-amiller@amilx.com>
References: <1331764019-5808-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed spaces before tabs and
moved while statement in front of '}'

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index d1a3e65..42307a3 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -439,8 +439,7 @@ void buffer_free(struct net_device *dev, struct buffer **buffer, int len, short
 		}
 		kfree(tmp);
 		tmp = next;
-	}
-	while (next != *buffer);
+	} while (next != *buffer);
 
 	*buffer = NULL;
 }
@@ -1618,9 +1617,9 @@ void rtl8180_rx(struct net_device *dev)
 		if (IEEE80211_FTYPE_CTL != type &&
 		    !bHwError && !bCRC && !bICV &&
 		    eqMacAddr(priv->ieee80211->current_network.bssid,
-		    	fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
-		    	fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
-		    	hdr->addr3)) {
+			fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
+			fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
+			hdr->addr3)) {
 
 			/* Perform signal smoothing for dynamic
 			 * mechanism on demand. This is different
@@ -3736,7 +3735,7 @@ static int __init rtl8180_pci_module_init(void)
 	DMESG("Wireless extensions version %d", WIRELESS_EXT);
 	rtl8180_proc_module_init();
 
-      if (pci_register_driver(&rtl8180_pci_driver)) {
+	if (pci_register_driver(&rtl8180_pci_driver)) {
 		DMESG("No device found");
 		return -ENODEV;
 	}
-- 
1.7.7.6

