Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2HCMgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:36:17 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39885 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2HCMgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:36:15 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] emulex: benet: Add a missing CR in the end of message
Date: Fri,  3 Aug 2012 21:36:51 +0900
Message-Id: <1343997411-10465-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc1.16.g05a20c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing a CR in printk causes 2 messages printed in one line.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 896f283..82031d3 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1916,7 +1916,7 @@ static int be_rx_cqs_create(struct be_adapter *adapter)
 
 	if (adapter->num_rx_qs != MAX_RX_QS)
 		dev_info(&adapter->pdev->dev,
-			"Created only %d receive queues", adapter->num_rx_qs);
+			"Created only %d receive queues\n", adapter->num_rx_qs);
 
 	return 0;
 }
-- 
1.7.12.rc1

