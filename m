Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1HBTS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:18:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64883 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1HBTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:18:54 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4][TRIVIAL]staging: et131x: Remove redundant commented out code
Date: Tue,  2 Aug 2011 20:17:49 +0100
Message-Id: <1312312672-3639-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed commented out calls that no longer exist in the net_device struct.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_netdev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index da60be7..93ef9d5 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -669,8 +669,7 @@ struct net_device *et131x_device_alloc(void)
 	/* Setup the function registration table (and other data) for a
 	 * net_device
 	 */
-	/* netdev->init               = &et131x_init; */
-	/* netdev->set_config = &et131x_config; */
+
 	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
 	netdev->netdev_ops = &et131x_netdev_ops;
 
-- 
1.7.4.4

