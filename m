Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150Ab2GLOY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:24:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:10781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161123Ab2GLOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:24:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121595870"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 2/4] hfsplus: amend debugging print
Date: Thu, 12 Jul 2012 17:26:29 +0300
Message-Id: <1342103191-17406-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
References: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Print correct function name in the debugging print of the
'hfsplus_sync_fs()' function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfsplus/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 5df771e..9e9c2788 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -171,7 +171,7 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 	if (!wait)
 		return 0;
 
-	dprint(DBG_SUPER, "hfsplus_write_super\n");
+	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
 	sb->s_dirt = 0;
 
-- 
1.7.7.6

