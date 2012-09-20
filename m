Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2ITOXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:23:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47893 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2ITOXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:23:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: [PATCH v2 03/10] acct: constify the name arg to acct_on
Date: Thu, 20 Sep 2012 10:23:12 -0400
Message-Id: <1348150999-13028-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
References: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
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

