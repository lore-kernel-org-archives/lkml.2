Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2BIOiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:38:13 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37537
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756580Ab2BIOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:38:12 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dillowda@ornl.gov, linux-rdma@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] SRP: Fix typo in ib_srpt.c
Date: Thu,  9 Feb 2012 23:37:43 +0900
Message-Id: <1328798263-1921-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "alocate" to "allocate" in
drivers/infiniband/ulp/srpt/ib_srpt.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2b73d43..ebe33d9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3450,7 +3450,7 @@ static struct se_node_acl *srpt_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct srpt_node_acl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to alocate struct srpt_node_acl\n");
+		printk(KERN_ERR "Unable to allocate struct srpt_node_acl\n");
 		return NULL;
 	}
 
-- 
1.7.6.5

