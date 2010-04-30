Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab0D3Qzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:55:55 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:48766 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab0D3Qzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bg9Bt+5Jo1Y3BS5B+penBT3nfGJJGdMUuBx0yyMpcXVj13kM7kIqe3mUQ8fmZJco96
         11jRQioE81pMqn5cWWFnqVqKLWMZgXr4+QFlUdVeSmkyjTEQn082Wk+tLQSD/J14RRVW
         fqdJRlVYb8YTgutRybG6A5020BFYmemE7OQqw=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: arlan: fixed space before tabs style issue in arlan-main.c
Date: Fri, 30 Apr 2010 21:57:33 +0530
Message-Id: <1272644853-8118-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the arlan-main.c file that fixes all the
space before tabs warnings found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/arlan/arlan-main.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/arlan/arlan-main.c b/drivers/staging/arlan/arlan-main.c
index 943df89..b0af8d3 100644
--- a/drivers/staging/arlan/arlan-main.c
+++ b/drivers/staging/arlan/arlan-main.c
@@ -76,19 +76,19 @@ MODULE_PARM_DESC(entry_and_exit_debug, "Arlan driver function entry and exit deb
 struct arlan_conf_stru arlan_conf[MAX_ARLANS];
 static int arlans_found;
 
-static  int 	arlan_open(struct net_device *dev);
-static  netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev);
-static  irqreturn_t arlan_interrupt(int irq, void *dev_id);
-static  int 	arlan_close(struct net_device *dev);
-static  struct net_device_stats *
+static int	arlan_open(struct net_device *dev);
+static netdev_tx_t arlan_tx(struct sk_buff *skb, struct net_device *dev);
+static irqreturn_t arlan_interrupt(int irq, void *dev_id);
+static int	arlan_close(struct net_device *dev);
+static struct net_device_stats *
 		arlan_statistics		(struct net_device *dev);
-static  void 	arlan_set_multicast		(struct net_device *dev);
-static  int 	arlan_hw_tx			(struct net_device* dev, char *buf, int length );
-static  int	arlan_hw_config			(struct net_device * dev);
-static  void 	arlan_tx_done_interrupt		(struct net_device * dev, int status);
-static  void	arlan_rx_interrupt		(struct net_device * dev, u_char rxStatus, u_short, u_short);
-static  void	arlan_process_interrupt		(struct net_device * dev);
-static	void	arlan_tx_timeout		(struct net_device *dev);
+static void	arlan_set_multicast		(struct net_device *dev);
+static int	arlan_hw_tx			(struct net_device* dev, char *buf, int length );
+static int	arlan_hw_config			(struct net_device * dev);
+static void	arlan_tx_done_interrupt		(struct net_device * dev, int status);
+static void	arlan_rx_interrupt		(struct net_device * dev, u_char rxStatus, u_short, u_short);
+static void	arlan_process_interrupt		(struct net_device * dev);
+static void	arlan_tx_timeout		(struct net_device *dev);
 
 static inline long us2ticks(int us)
 {
@@ -885,7 +885,7 @@ static int __init arlan_check_fingerprint(unsigned long memaddr)
 
 	/* check for card at this address */
 	if (0 != strncmp(tempBuf, probeText, 29)) {
- 		release_mem_region(paddr, ARLAN_SHMEM_SIZE);
+		release_mem_region(paddr, ARLAN_SHMEM_SIZE);
 		return -ENODEV;
 	}
 
-- 
1.6.0.4

