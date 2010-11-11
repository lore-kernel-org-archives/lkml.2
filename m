Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0KKLXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:23:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:65200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0KKLXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:23:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,182,1288594800"; 
   d="scan'208";a="856470821"
Date: Thu, 11 Nov 2010 19:23:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trivial Patch Monkey <trivial@kernel.org>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: fix redirty_page_for_writepage() typo in comment
Message-ID: <20101111112329.GA6923@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1916164..b82fbd9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3357,7 +3357,7 @@ int ext4_alloc_da_blocks(struct inode *inode)
 	 * doing I/O at all.
 	 *
 	 * We could call write_cache_pages(), and then redirty all of
-	 * the pages by calling redirty_page_for_writeback() but that
+	 * the pages by calling redirty_page_for_writepage() but that
 	 * would be ugly in the extreme.  So instead we would need to
 	 * replicate parts of the code in the above functions,
 	 * simplifying them becuase we wouldn't actually intend to
