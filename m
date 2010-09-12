Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0ILFLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1764 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0ILFLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:08 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] drivers/infiniband: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:55 -0700
Message-Id: <6dddde24a319352fbece72450b35eb5d2176f292.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/amso1100/c2_intr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/infiniband/hw/amso1100/c2_intr.c
index 3b50954..0ebe4e8 100644
--- a/drivers/infiniband/hw/amso1100/c2_intr.c
+++ b/drivers/infiniband/hw/amso1100/c2_intr.c
@@ -62,8 +62,8 @@ void c2_rnic_interrupt(struct c2_dev *c2dev)
 static void handle_mq(struct c2_dev *c2dev, u32 mq_index)
 {
 	if (c2dev->qptr_array[mq_index] == NULL) {
-		pr_debug(KERN_INFO "handle_mq: stray activity for mq_index=%d\n",
-			mq_index);
+		pr_debug("handle_mq: stray activity for mq_index=%d\n",
+			 mq_index);
 		return;
 	}
 
-- 
1.7.3.rc1

