Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0JROlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab0JROhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/22] GFS2: Fix whitespace in previous patch
Date: Mon, 18 Oct 2010 15:15:30 +0100
Message-Id: <1287411346-17855-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the offending space

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index f6da0d7..ce4f1df 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1423,7 +1423,7 @@ static void calc_max_reserv(struct gfs2_inode *ip, loff_t max, loff_t *len,
 		max_data -= tmp;
 	}
 	/* This calculation isn't the exact reverse of gfs2_write_calc_reserve,
- 	   so it might end up with fewer data blocks */
+	   so it might end up with fewer data blocks */
 	if (max_data <= *data_blocks)
 		return;
 	*data_blocks = max_data;
-- 
1.7.1.1

