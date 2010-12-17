Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0LQMsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:48:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0LQMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/15] GFS2: Remove duplicate #defines from glock.h
Date: Fri, 17 Dec 2010 12:24:15 +0000
Message-Id: <1292588661-14350-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of duplicated #defines in glock.h
plus one which is unused. This removes the extra
definitions.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index ba6865c..691851c 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -87,7 +87,6 @@ enum {
 #define GL_ASYNC		0x00000040
 #define GL_EXACT		0x00000080
 #define GL_SKIP			0x00000100
-#define GL_ATIME		0x00000200
 #define GL_NOCACHE		0x00000400
   
 /*
@@ -126,19 +125,6 @@ struct lm_lockops {
 	const match_table_t *lm_tokens;
 };
 
-#define LM_FLAG_TRY		0x00000001
-#define LM_FLAG_TRY_1CB		0x00000002
-#define LM_FLAG_NOEXP		0x00000004
-#define LM_FLAG_ANY		0x00000008
-#define LM_FLAG_PRIORITY	0x00000010
-
-#define GL_ASYNC		0x00000040
-#define GL_EXACT		0x00000080
-#define GL_SKIP			0x00000100
-#define GL_NOCACHE		0x00000400
-
-#define GLR_TRYFAILED		13
-
 extern struct workqueue_struct *gfs2_delete_workqueue;
 static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
 {
-- 
1.7.3.3

