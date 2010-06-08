Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0FHDvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:51:25 -0400
Received: from mail.perches.com ([173.55.12.10]:2763 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab0FHDuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:50 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] fs/ufs/util.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:44 -0700
Message-Id: <daaec6ef41bf96e7d3fcd04556c52acc58fefb9e.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ufs/util.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index 85a7fc9..9c44f32 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -26,8 +26,7 @@ struct ufs_buffer_head * _ubh_bread_ (struct ufs_sb_private_info * uspi,
 	count = size >> uspi->s_fshift;
 	if (count > UFS_MAXFRAG)
 		return NULL;
-	ubh = (struct ufs_buffer_head *)
-		kmalloc (sizeof (struct ufs_buffer_head), GFP_KERNEL);
+	ubh = kmalloc(sizeof(struct ufs_buffer_head), GFP_KERNEL);
 	if (!ubh)
 		return NULL;
 	ubh->fragment = fragment;
-- 
1.7.1.244.gbdc4

