Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1LSOUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:20:55 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:45602
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752527Ab1LSOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:20:53 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, jkosina@suse.cz, Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [Trivial]: nfs : Fix typo in dir.c
Date: Mon, 19 Dec 2011 23:17:03 +0900
Message-Id: <1324304223-10047-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo "iff" -> "if" in dir.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
To: linux-nfs@vger.kernel.org
---
 fs/nfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ac28990..ad32d4e 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1127,7 +1127,7 @@ static int nfs_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (nfs_have_delegation(inode, FMODE_READ))
 		goto out_set_verifier;
 
-	/* Force a full look up iff the parent directory has changed */
+	/* Force a full look up if the parent directory has changed */
 	if (!nfs_is_exclusive_create(dir, nd) && nfs_check_verifier(dir, dentry)) {
 		if (nfs_lookup_verify_inode(inode, nd))
 			goto out_zap_parent;
-- 
1.7.6.4

