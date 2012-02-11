Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab2BKL56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:57:58 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46743
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753318Ab2BKL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:57:57 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: j@w1.fi, linux-wireless@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] hostap: Fix typo in hostap_hw.c
Date: Sat, 11 Feb 2012 20:56:59 +0900
Message-Id: <1328961419-1682-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
drivers/net/wireless/hostap/hostap_hw.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/hostap/hostap_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index aa15cc4..50f87b6 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -1466,7 +1466,7 @@ static int prism2_hw_enable(struct net_device *dev, int initial)
 	 * before it starts acting as an AP, so reset port automatically
 	 * here just in case */
 	if (initial && prism2_reset_port(dev)) {
-		printk("%s: MAC port 0 reseting failed\n", dev->name);
+		printk("%s: MAC port 0 resetting failed\n", dev->name);
 		return 1;
 	}
 
@@ -1557,7 +1557,7 @@ static void prism2_hw_reset(struct net_device *dev)
 	static long last_reset = 0;
 
 	/* do not reset card more than once per second to avoid ending up in a
-	 * busy loop reseting the card */
+	 * busy loop resetting the card */
 	if (time_before_eq(jiffies, last_reset + HZ))
 		return;
 	last_reset = jiffies;
-- 
1.7.6.5

