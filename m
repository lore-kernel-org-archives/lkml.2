Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0CXSrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:47:39 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61154 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932543Ab0CXSqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:46:37 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, Corey Thomas <coreythomas@charter.net>
Subject: [PATCH 6/7] wireless/raylink: remove trailing space in messages
Date: Wed, 24 Mar 2010 19:46:34 +0100
Message-Id: <1269456395-15343-6-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201003241927.12434.elendil@planet.nl>
References: <201003241927.12434.elendil@planet.nl>
X-OriginalArrivalTime: 24 Mar 2010 18:46:36.0225 (UTC) FILETIME=[54CAE310:01CACB82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Corey Thomas <coreythomas@charter.net>
---
 drivers/net/wireless/ray_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 84c530a..8d173cc 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -556,7 +556,7 @@ static int ray_init(struct net_device *dev)
 	local->fw_ver = local->startup_res.firmware_version[0];
 	local->fw_bld = local->startup_res.firmware_version[1];
 	local->fw_var = local->startup_res.firmware_version[2];
-	dev_dbg(&link->dev, "ray_init firmware version %d.%d \n", local->fw_ver,
+	dev_dbg(&link->dev, "ray_init firmware version %d.%d\n", local->fw_ver,
 	      local->fw_bld);
 
 	local->tib_length = 0x20;
@@ -2252,7 +2252,7 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
 			     FCS_LEN)) {
 				pr_debug(
-				      "ray_cs invalid packet length %d received \n",
+				      "ray_cs invalid packet length %d received\n",
 				      rx_len);
 				return;
 			}
@@ -2263,7 +2263,7 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 			    (dev->mtu + RX_MAC_HEADER_LENGTH + ETH_HLEN +
 			     FCS_LEN)) {
 				pr_debug(
-				      "ray_cs invalid packet length %d received \n",
+				      "ray_cs invalid packet length %d received\n",
 				      rx_len);
 				return;
 			}
@@ -2771,11 +2771,11 @@ static int ray_cs_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "Hop dwell            = %d Kus\n",
 				   pfh->dwell_time[0] +
 				   256 * pfh->dwell_time[1]);
-			seq_printf(m, "Hop set              = %d \n",
+			seq_printf(m, "Hop set              = %d\n",
 				   pfh->hop_set);
-			seq_printf(m, "Hop pattern          = %d \n",
+			seq_printf(m, "Hop pattern          = %d\n",
 				   pfh->hop_pattern);
-			seq_printf(m, "Hop index            = %d \n",
+			seq_printf(m, "Hop index            = %d\n",
 				   pfh->hop_index);
 			p += p[1] + 2;
 		} else {
-- 
1.6.6.1

