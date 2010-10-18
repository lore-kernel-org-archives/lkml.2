Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0JROiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab0JROiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:38:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/22] GFS2: fixed typo
Date: Mon, 18 Oct 2010 15:15:46 +0100
Message-Id: <1287411346-17855-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 2bda191..db1c26d 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -215,7 +215,7 @@ void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**
- * gfs2_glock_nq_init - intialize a holder and enqueue it on a glock
+ * gfs2_glock_nq_init - initialize a holder and enqueue it on a glock
  * @gl: the glock
  * @state: the state we're requesting
  * @flags: the modifier flags
-- 
1.7.1.1

