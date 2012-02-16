Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2BPNZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:25:53 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:47416
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2BPNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:25:52 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] ethernet: Fix typo in lantiq_etop.c
Date: Thu, 16 Feb 2012 22:25:19 +0900
Message-Id: <1329398719-1810-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "platfom" to "platform" in
drivers/net/ethernet/lantiq_etop.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/ethernet/lantiq_etop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 85e2c6c..24d67c2 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -792,7 +792,7 @@ init_ltq_etop(void)
 	int ret = platform_driver_probe(&ltq_mii_driver, ltq_etop_probe);
 
 	if (ret)
-		pr_err("ltq_etop: Error registering platfom driver!");
+		pr_err("ltq_etop: Error registering platform driver!");
 	return ret;
 }
 
-- 
1.7.4.4

