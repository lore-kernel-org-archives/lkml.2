Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1DKKOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:14:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34724 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1DKKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=CvtdBxAf8wC9gxibw0jz8R37OhSk9i5Epkhvb3qaeqoifaxiST5dRnRAtYlRTxEmAA
         RKBgDB1TQp5mdzb5ddonp435nz5m9XoPaTrNisWdA3BwKcoRqa9Hd2ISkQvLT8iLToJG
         n77seGBL0XfAtjTVjsSKk9SREO9qhjelXnpAY=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        Lucas De Marchi <lucas.demarchi@profusion.mobi> (commit_signer:1/3=33%),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] net: fix tranmitted/tranmitting typo
Date: Mon, 11 Apr 2011 18:15:57 +0800
Message-Id: <1302516958-9535-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace tranmitted with transmitted.
replace tranmitting with transmitting.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.h      |    2 +-
 drivers/net/tokenring/3c359.c       |    4 ++--
 drivers/net/tokenring/lanstreamer.c |    2 +-
 drivers/net/tokenring/olympic.c     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.h b/drivers/net/bonding/bond_alb.h
index 86861f0..9af19fa 100644
--- a/drivers/net/bonding/bond_alb.h
+++ b/drivers/net/bonding/bond_alb.h
@@ -75,7 +75,7 @@ struct tlb_client_info {
 				 * gave this entry index.
 				 */
 	u32 tx_bytes;		/* Each Client accumulates the BytesTx that
-				 * were tranmitted to it, and after each
+				 * were transmitted to it, and after each
 				 * CallBack the LoadHistory is divided
 				 * by the balance interval
 				 */
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index 8a3b191..ff32bef 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -1251,7 +1251,7 @@ static netdev_tx_t xl_xmit(struct sk_buff *skb, struct net_device *dev)
 /* 
  * The NIC has told us that a packet has been downloaded onto the card, we must
  * find out which packet it has done, clear the skb and information for the packet
- * then advance around the ring for all tranmitted packets
+ * then advance around the ring for all transmitted packets
  */
 
 static void xl_dn_comp(struct net_device *dev) 
@@ -1568,7 +1568,7 @@ static void xl_arb_cmd(struct net_device *dev)
 			if (lan_status_diff & LSC_SOFT_ERR)
 					printk(KERN_WARNING "%s: Adapter transmitted Soft Error Report Mac Frame\n",dev->name);
 			if (lan_status_diff & LSC_TRAN_BCN) 
-					printk(KERN_INFO "%s: We are tranmitting the beacon, aaah\n",dev->name);
+					printk(KERN_INFO "%s: We are transmitting the beacon, aaah\n",dev->name);
 			if (lan_status_diff & LSC_SS) 
 					printk(KERN_INFO "%s: Single Station on the ring\n", dev->name);
 			if (lan_status_diff & LSC_RING_REC)
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 5bd1407..9354ca9 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -1675,7 +1675,7 @@ drop_frame:
 			if (lan_status_diff & LSC_SOFT_ERR)
 				printk(KERN_WARNING "%s: Adapter transmitted Soft Error Report Mac Frame\n", dev->name);
 			if (lan_status_diff & LSC_TRAN_BCN)
-				printk(KERN_INFO "%s: We are tranmitting the beacon, aaah\n", dev->name);
+				printk(KERN_INFO "%s: We are transmitting the beacon, aaah\n", dev->name);
 			if (lan_status_diff & LSC_SS)
 				printk(KERN_INFO "%s: Single Station on the ring\n", dev->name);
 			if (lan_status_diff & LSC_RING_REC)
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index 3d2fbe6..2684003 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -1500,7 +1500,7 @@ drop_frame:
 			if (lan_status_diff & LSC_SOFT_ERR)
 					printk(KERN_WARNING "%s: Adapter transmitted Soft Error Report Mac Frame\n",dev->name);
 			if (lan_status_diff & LSC_TRAN_BCN) 
-					printk(KERN_INFO "%s: We are tranmitting the beacon, aaah\n",dev->name);
+					printk(KERN_INFO "%s: We are transmitting the beacon, aaah\n",dev->name);
 			if (lan_status_diff & LSC_SS) 
 					printk(KERN_INFO "%s: Single Station on the ring\n", dev->name);
 			if (lan_status_diff & LSC_RING_REC)
-- 
1.7.4

