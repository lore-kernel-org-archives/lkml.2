Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0EQNA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab0EQM6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/11] GFS2: Remove space from slab cache name
Date: Mon, 17 May 2010 13:40:15 +0100
Message-Id: <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently this might confuse parsers.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index a88fadc..fb2a5f9 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -94,7 +94,7 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_glock_cachep)
 		goto fail;
 
-	gfs2_glock_aspace_cachep = kmem_cache_create("gfs2_glock (aspace)",
+	gfs2_glock_aspace_cachep = kmem_cache_create("gfs2_glock(aspace)",
 					sizeof(struct gfs2_glock) +
 					sizeof(struct address_space),
 					0, 0, gfs2_init_gl_aspace_once);
-- 
1.6.2.5

