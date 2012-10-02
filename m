Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2JBAZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:25:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36736 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2JBARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:33 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 20/49] vfs: unexport getname and putname symbols
Date: Mon,  1 Oct 2012 20:16:29 -0400
Message-Id: <1349137018-21948-21-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no callers in module code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 48cb4aa..d3f8998 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -209,7 +209,6 @@ getname(const char __user * filename)
 {
 	return getname_flags(filename, 0, NULL);
 }
-EXPORT_SYMBOL(getname);
 
 void putname(struct getname_info *ginfo)
 {
@@ -219,7 +218,6 @@ void putname(struct getname_info *ginfo)
 #endif
 	final_putname(ginfo);
 }
-EXPORT_SYMBOL(putname);
 
 static int check_acl(struct inode *inode, int mask)
 {
-- 
1.7.11.4

