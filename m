Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2JBA1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:27:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57346 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2JBARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 13/49] acct: constify the name arg to acct_on
Date: Mon,  1 Oct 2012 20:16:22 -0400
Message-Id: <1349137018-21948-14-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 02e6167..e97d159 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -193,7 +193,7 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 	}
 }
 
-static int acct_on(char *name)
+static int acct_on(const char *name)
 {
 	struct file *file;
 	struct vfsmount *mnt;
-- 
1.7.11.4

