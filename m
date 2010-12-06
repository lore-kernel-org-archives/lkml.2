Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0LFWHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:47 -0500
Received: from mail.perches.com ([173.55.12.10]:2335 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/29] fs/notify/inotify: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:07 -0800
Message-Id: <8016aa2868e0d684e32bf09f44d570023bdc8033.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
1.7.3.2.245.g03276.dirty

