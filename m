Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EEIwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:52:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48379 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1EEIwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HlWtE9KT/NuoXHmtTVxSZ2rkZ9jvxWCZvGDWFEfw1LQSwPs7y7kJeEPkzPltYVKBbb
         1/W26yigac1z+w1n36EXX7zuJW164BCvvW9HprUHWfP5EuKNkPq8v9MDg0PBKCZhBoxO
         CO85MLAfxS7tyhasHxXALekCDxw8opIruxDDo=
From: Robin Dong <hao.bigrat@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 2/3] ocfs2: change incorrect 'extern' keyword to 'static'
Date: Thu,  5 May 2011 16:51:57 +0800
Message-Id: <1304585518-9665-2-git-send-email-sanbai@taobao.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
References: <1304585518-9665-1-git-send-email-sanbai@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change function param_set_dlmfs_capabilities from 'extern' to 'static' since
function param_get_dlmfs_capabilities is also 'static'.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index b2df490..dd2675e 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -88,7 +88,7 @@ struct workqueue_struct *user_dlm_worker;
  *		  signifies a bast fired on the lock.
  */
 #define DLMFS_CAPABILITIES "bast stackglue"
-extern int param_set_dlmfs_capabilities(const char *val,
+static int param_set_dlmfs_capabilities(const char *val,
 					struct kernel_param *kp)
 {
 	printk(KERN_ERR "%s: readonly parameter\n", kp->name);
-- 
1.7.1

