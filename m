Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1ACIyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 03:54:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33998 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1ACIyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 03:54:14 -0500
From: Michal Simek <monstr@monstr.eu>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] trivial: Fix typo fault in netdevice.h
Date: Mon,  3 Jan 2011 09:54:09 +0100
Message-Id: <1294044849-10601-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/linux/netdevice.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d8fd2c2..c773bc8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -683,7 +683,7 @@ struct netdev_rx_queue {
  *	   neither operation.
  *
  * void (*ndo_vlan_rx_register)(struct net_device *dev, struct vlan_group *grp);
- *	If device support VLAN receive accleration
+ *	If device support VLAN receive acceleration
  *	(ie. dev->features & NETIF_F_HW_VLAN_RX), then this function is called
  *	when vlan groups for the device changes.  Note: grp is NULL
  *	if no vlan's groups are being used.
-- 
1.5.5.6

