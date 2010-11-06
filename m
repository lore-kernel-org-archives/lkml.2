Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0KFQWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:22:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63103 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0KFQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A7P6caTllHADPzsTO74Tstrzr4Bcvpa8sEgvBgulPPP4nAhlJLgVhSB4M++2bCA96k
         dhMoijs9XCiIW0PmfbkXopDCF8gegAFEmvbapnxjVwRQ9IffugdZcdkGiXGUQFg0MhVl
         mWk0Ht5C8U6KOXdinVM7rnbXqSWdVr0H/QnY4=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] Staging: wlan-ng: fixed coding style issues in p80211netdev.c
Date: Sat,  6 Nov 2010 18:21:59 +0200
Message-Id: <1289060520-13741-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the p80211netdev.c file that fixes warnings that were found by the checkpatch.pl tool

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index aa1792c..aa7f4f9 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -301,7 +301,8 @@ static void p80211netdev_rx_bh(unsigned long arg)
 					if (memcmp
 					    (hdr->a1, wlandev->netdev->dev_addr,
 					     ETH_ALEN) != 0) {
-						/* but reject anything else that isn't multicast */
+						/* but reject anything else that
+						   isn't multicast */
 						if (!(hdr->a1[0] & 0x01)) {
 							dev_kfree_skb(skb);
 							continue;
@@ -770,7 +771,8 @@ int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 	}
 
 	/* Allocate and initialize the struct device */
-	netdev = alloc_netdev(sizeof(struct wireless_dev), "wlan%d", ether_setup);
+	netdev = alloc_netdev(sizeof(struct wireless_dev), "wlan%d",
+		ether_setup);
 	if (netdev == NULL) {
 		printk(KERN_ERR "Failed to alloc netdev.\n");
 		wlan_free_wiphy(wiphy);
-- 
1.7.1

