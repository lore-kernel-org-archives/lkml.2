Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2FLFPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:15:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2FLFPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:15:12 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] mm/page-writeback.c: fix comment error
Date: Tue, 12 Jun 2012 13:15:03 +0800
Message-Id: <1339478103-8748-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c833bf0..c8945e0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -918,7 +918,7 @@ static void bdi_update_dirty_ratelimit(struct backing_dev_info *bdi,
 	 *	bdi->dirty_ratelimit = balanced_dirty_ratelimit;
 	 *
 	 * However to get a more stable dirty_ratelimit, the below elaborated
-	 * code makes use of task_ratelimit to filter out sigular points and
+	 * code makes use of task_ratelimit to filter out singular points and
 	 * limit the step size.
 	 *
 	 * The below code essentially only uses the relative value of
-- 
1.7.9.5

