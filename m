Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2FMLgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:36:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:16557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2FMLgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157039732"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] hfsplus: amend debugging print
Date: Wed, 13 Jun 2012 14:37:49 +0300
Message-Id: <1339587471-2713-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
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

