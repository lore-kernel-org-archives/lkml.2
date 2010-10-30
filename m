Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0J3VMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:12:39 -0400
Received: from mail.perches.com ([173.55.12.10]:3766 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0J3VJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:41 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 25/39] fs/notify/inotify: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:42 -0700
Message-Id: <dc0d0d51b762ee2c20006752542a07de02620041.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/notify/inotify/inotify_fsnotify.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index a91b69a..aa283e4 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -177,8 +177,8 @@ static int idr_callback(int id, void *p, void *data)
 	fsn_mark = p;
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	WARN(1, "inotify closing but id=%d for fsn_mark=%p in group=%p still in "
-		"idr.  Probably leaking memory\n", id, p, data);
+	WARN(1, "inotify closing but id=%d for fsn_mark=%p in group=%p still in idr.  Probably leaking memory\n",
+	     id, p, data);
 
 	/*
 	 * I'm taking the liberty of assuming that the mark in question is a
-- 
1.7.3.1.g432b3.dirty

