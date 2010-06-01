Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0FADYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:24:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2494 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab0FADXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:34 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH 18/21] fs/ufs/util.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:20 -0700
Message-Id: <c4691bb47c82a9f13e79e4ebeb44b884d282651b.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
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
1.7.0.3.311.g6a6955

