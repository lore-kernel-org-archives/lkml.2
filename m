Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab0KODHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:07:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1249 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730Ab0KODGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:06:00 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 38/44] include/linux/if_macvlan.h: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:57 -0800
Message-Id: <186ca914f887b2354ea3178696edc81cacbb28c6.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/if_macvlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 8a2fd66..ac96a2d 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -69,7 +69,7 @@ static inline void macvlan_count_rx(const struct macvlan_dev *vlan,
 	rx_stats = this_cpu_ptr(vlan->rx_stats);
 	if (likely(success)) {
 		u64_stats_update_begin(&rx_stats->syncp);
-		rx_stats->rx_packets++;;
+		rx_stats->rx_packets++;
 		rx_stats->rx_bytes += len;
 		if (multicast)
 			rx_stats->rx_multicast++;
-- 
1.7.3.1.g432b3.dirty

