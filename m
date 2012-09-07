Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717Ab2IGNj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:39:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37872 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189Ab2IGNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 03/10] acct: constify the name arg to acct_on
Date: Fri,  7 Sep 2012 09:37:58 -0400
Message-Id: <1347025085-20285-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
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

