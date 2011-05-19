Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1ESJKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1ESJKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/32] GFS2: Remove unused macro
Date: Thu, 19 May 2011 09:47:04 +0100
Message-Id: <1305794847-3291-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer_in_io() macro has been unused for some time,
so remove it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 6a1d9ba..22c5265 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -77,8 +77,6 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen);
 
 #define buffer_busy(bh) \
 ((bh)->b_state & ((1ul << BH_Dirty) | (1ul << BH_Lock) | (1ul << BH_Pinned)))
-#define buffer_in_io(bh) \
-((bh)->b_state & ((1ul << BH_Dirty) | (1ul << BH_Lock)))
 
 #endif /* __DIO_DOT_H__ */
 
-- 
1.7.4

