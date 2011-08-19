Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1HSVcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:32:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11598 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1HSVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:32:12 -0400
Date: Fri, 19 Aug 2011 23:32:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 2/3] Add documentation comment for ntfs_free()
In-Reply-To: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1108192332160.31857@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/ntfs/malloc.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
index d833e37..174408b 100644
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -83,6 +83,12 @@ static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
 	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOFAIL);
 }
 
+/**
+ * ntfs_free - free memory allocated by ntfs_malloc*
+ * @addr:	pointer to the memory to be freed
+ *
+ * Frees the memory pointed to by @addr. It is safe to pass a NULL pointer.
+ */
 static inline void ntfs_free(void *addr)
 {
 	if (!addr)
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

