Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1C1Qar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63976 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1C1Qan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hB+ubHsguPBKMFufQanpzFWalBAXw2MuxZ2WzgFaY6d2v97T+XhdAGVimRBJ043Xto
         56IdjDcnMoJ1BTS+8QulzqvI4UJAqFeqZagnmsha5Z3/WGG3Ue7CRWg+hQZYYPlfQRVn
         0PjSq5tGq9RaxRc+vrXJwTVDYd0CjG03aEm9U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 19/25]fs Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:42 -0700
Message-Id: <1301329788-3423-20-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/btrfs/ctree.h |    1 -
 fs/omfs/file.c   |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7f78cc7..7bdeece 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -19,7 +19,6 @@
 #ifndef __BTRFS_CTREE__
 #define __BTRFS_CTREE__
 
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/fs.h>
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index d738a7e..2c6d952 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -4,7 +4,6 @@
  * Released under GPL v2.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-- 
1.7.4.1

