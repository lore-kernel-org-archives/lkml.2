Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030436Ab2CSKtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297Ab2CSKts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/12] GFS2: Make bd_cmp() static
Date: Mon, 19 Mar 2012 10:25:21 +0000
Message-Id: <1332152728-4027-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing static to bd_cmp()

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index b8fe7b7..2b9f0d9 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -567,7 +567,7 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 	log_write_header(sdp, 0, 0);
 }
 
-int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
+static int bd_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct gfs2_bufdata *bda, *bdb;
 
-- 
1.7.4

