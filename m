Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2CEXII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:08:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:46538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2CEXIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:08:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133898834"
Date: Mon, 5 Mar 2012 15:08:06 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: fix typo in writeback_inodes_sb_nr_if_idle()
 comment header
Message-ID: <20120305230806.GA19971@localhost>
References: <20120305230602.GA19073@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305230602.GA19073@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2012-03-01 22:15:30.753778139 -0800
+++ linux/fs/fs-writeback.c	2012-03-03 16:13:47.765894081 -0800
@@ -1548,17 +1548,17 @@ int writeback_inodes_sb_if_idle(struct s
 		up_read(&sb->s_umount);
 		return 1;
 	} else
 		return 0;
 }
 EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
 
 /**
- * writeback_inodes_sb_if_idle	-	start writeback if none underway
+ * writeback_inodes_sb_nr_if_idle	-	start writeback if none underway
  * @sb: the superblock
  * @nr: the number of pages to write
  * @reason: reason why some writeback work was initiated
  *
  * Invoke writeback_inodes_sb if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
  */
 int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
