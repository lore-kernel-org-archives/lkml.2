Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab2GYPLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:44939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab2GYPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267702"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 11/16] hfs: nuke write_super from comments
Date: Wed, 25 Jul 2012 18:12:09 +0300
Message-Id: <1343229134-29487-12-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from hfs.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/hfs/mdb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 5fd51a5..b7ec224 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -236,10 +236,10 @@ out:
  * hfs_mdb_commit()
  *
  * Description:
- *   This updates the MDB on disk (look also at hfs_write_super()).
+ *   This updates the MDB on disk.
  *   It does not check, if the superblock has been modified, or
  *   if the filesystem has been mounted read-only. It is mainly
- *   called by hfs_write_super() and hfs_btree_extend().
+ *   called by hfs_sync_fs() and flush_mdb().
  * Input Variable(s):
  *   struct hfs_mdb *mdb: Pointer to the hfs MDB
  *   int backup;
-- 
1.7.10

