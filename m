Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab0KODIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:08:41 -0500
Received: from mail.perches.com ([173.55.12.10]:1236 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab0KODF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:58 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 35/44] fs/nfs: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:54 -0800
Message-Id: <ec29c2321578915d1d219f5ad00b876a3ff1a105.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/nfs/getroot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index ac7b814..e17f628 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -190,7 +190,7 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 
 	fattr = nfs_alloc_fattr();
 	if (fattr == NULL)
-		return ERR_PTR(-ENOMEM);;
+		return ERR_PTR(-ENOMEM);
 
 	/* get the actual root for this mount */
 	error = server->nfs_client->rpc_ops->getattr(server, mntfh, fattr);
-- 
1.7.3.1.g432b3.dirty

