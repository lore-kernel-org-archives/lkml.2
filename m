Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0LZQmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 11:42:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64249 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0LZQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 11:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wqZYmyOcLG/6bRJCcc1nmqsLWJeKXkXEM10cNqgF2qOEgaolNDw/qo9DLAyBWv1sr1
         fJ1rx4ARY5LDiNW77s5kDdsiBpRS7S2vly6B4LJBU7tVrUAGIeuWLF5eWqNYq/ifx6Mh
         wmlO0G9k92ffXB/q530t5ZuJbHZyfQ+FYF25w=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH 2/3] compat: update comment of compat statfs syscalls
Date: Mon, 27 Dec 2010 01:41:53 +0900
Message-Id: <1293381714-5264-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
In-Reply-To: <1293381714-5264-1-git-send-email-namhyung@gmail.com>
References: <1293381714-5264-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 7ed1ee6118ae ("Take statfs variants to fs/statfs.c")
separates out statfs syscalls from fs/open.c. Thus the comment
should be changed also.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>
---
 fs/compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 0a22f973f4b5..037df434b038 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -257,7 +257,7 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
 }
 
 /*
- * The following statfs calls are copies of code from fs/open.c and
+ * The following statfs calls are copies of code from fs/statfs.c and
  * should be checked against those from time to time
  */
 asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_statfs __user *buf)
-- 
1.7.3.4.600.g982838b0

