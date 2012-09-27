Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2I0Mw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2I0MwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:18 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] fs/namespace.c: remove unused macro MNT_WRITER_UNDERFLOW_LIMIT
Date: Thu, 27 Sep 2012 20:51:50 +0800
Message-Id: <1348750316-4138-2-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its users have gone.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/namespace.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3fdc239..dd969f8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -59,7 +59,6 @@ static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 	return tmp & (HASH_SIZE - 1);
 }
 
-#define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
 /*
  * allocation is serialized by namespace_sem, but we need the spinlock to
-- 
1.7.9.5

