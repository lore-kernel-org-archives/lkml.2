Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1E2RdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:33:08 -0400
Received: from asav4.lyse.net ([81.167.36.150]:54794 "EHLO asav4.lyse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab1E2RdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:33:03 -0400
X-Greylist: delayed 1541 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 13:33:03 EDT
From: August Lilleaas <august@augustl.com>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de,
        August Lilleaas <august@augustl.com>
Subject: [PATCH] Firewire: net: replacing deprecated __attribute__((packed)) with __packed
Date: Sun, 29 May 2011 19:07:19 +0200
Message-Id: <1306688839-18732-1-git-send-email-august@augustl.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a deprecation, replacing __attribute__((packed)) with __packed.

Signed-off-by: August Lilleaas <august@augustl.com>
---
 drivers/firewire/net.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index b9762d0..2e988ca 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -73,7 +73,7 @@ struct rfc2734_arp {
 	__be32 fifo_lo;		/* lo 32bits of sender's FIFO addr	*/
 	__be32 sip;		/* Sender's IP Address			*/
 	__be32 tip;		/* IP Address of requested hw addr	*/
-} __attribute__((packed));
+} __packed;
 
 /* This header format is specific to this driver implementation. */
 #define FWNET_ALEN	8
@@ -81,7 +81,7 @@ struct rfc2734_arp {
 struct fwnet_header {
 	u8 h_dest[FWNET_ALEN];	/* destination address */
 	__be16 h_proto;		/* packet type ID field */
-} __attribute__((packed));
+} __packed;
 
 /* IPv4 and IPv6 encapsulation header */
 struct rfc2734_header {
-- 
1.7.5.2

