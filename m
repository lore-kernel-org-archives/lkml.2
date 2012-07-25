Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252Ab2GYPL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:34632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552Ab2GYPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267816"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/16] gfs2: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:13 +0300
Message-Id: <1343229134-29487-16-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from gfs comments.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/gfs2/meta_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 6c1e5d1..cdfe84c 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -52,7 +52,7 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 		/*
 		 * If it's a fully non-blocking write attempt and we cannot
 		 * lock the buffer then redirty the page.  Note that this can
-		 * potentially cause a busy-wait loop from pdflush and kswapd
+		 * potentially cause a busy-wait loop from flusher thread and kswapd
 		 * activity, but those code paths have their own higher-level
 		 * throttling.
 		 */
-- 
1.7.10

