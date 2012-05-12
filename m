Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2ELIsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 04:48:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50638 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2ELIsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 04:48:12 -0400
From: liwp.linux@gmail.com
To: Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Cc: liwp.linux@gmail.com, Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] unmapped quotes
Date: Sat, 12 May 2012 16:47:40 +0800
Message-Id: <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp.linux@gmail.com>

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 26adea8..2b317a3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1155,7 +1155,7 @@ static long bdi_min_pause(struct backing_dev_info *bdi,
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to wait once crossing the (background_thresh + dirty_thresh) / 2.
- * If we're over `background_thresh' then the writeback threads are woken to
+ * If we're over 'background_thresh' then the writeback threads are woken to
  * perform some writeout.
  */
 static void balance_dirty_pages(struct address_space *mapping,
-- 
1.7.9.5

