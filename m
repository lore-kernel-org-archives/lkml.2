Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab2IGNi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:38:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43977 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621Ab2IGNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:38:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 10/10] vfs: unexport getname and putname symbols
Date: Fri,  7 Sep 2012 09:38:05 -0400
Message-Id: <1347025085-20285-11-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no callers in module code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 52feb98..6f9040c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -205,7 +205,6 @@ getname(const char __user * filename)
 {
 	return getname_flags(filename, 0, NULL);
 }
-EXPORT_SYMBOL(getname);
 
 void putname(struct getname_info *ginfo)
 {
@@ -215,7 +214,6 @@ void putname(struct getname_info *ginfo)
 #endif
 	final_putname(ginfo);
 }
-EXPORT_SYMBOL(putname);
 
 static int check_acl(struct inode *inode, int mask)
 {
-- 
1.7.11.4

