Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0IOMqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:46:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50994 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0IOMqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uKZJSHI276EMvgdM2I9JF1ZL4cvtkWLW6HbClMALigR6sITim/UVl+bfhFpaNHW9B4
         akP+iOyHjBAEvpzTrJdjP3AivKs+k6vme2GnPXTviei0VovxQNr63vLLKwatK5LxuKfd
         XRpkk8XgFqQrPpNF0jtPiNS8rbetaj1VN3LLI=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/2] ext2: trivial: fix a typo on comment in ext2/inode.c
Date: Wed, 15 Sep 2010 21:46:02 +0900
Message-Id: <1284554762-13278-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284554762-13278-1-git-send-email-namhyung@gmail.com>
References: <1284554762-13278-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'excpet' should be 'except'.
'ext3_get_branch' should be 'ext2_get_branch'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext2/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 940c961..533699c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -458,7 +458,7 @@ failed_out:
  *	the same format as ext2_get_branch() would do. We are calling it after
  *	we had read the existing part of chain and partial points to the last
  *	triple of that (one with zero ->key). Upon the exit we have the same
- *	picture as after the successful ext2_get_block(), excpet that in one
+ *	picture as after the successful ext2_get_block(), except that in one
  *	place chain is disconnected - *branch->p is still zero (we did not
  *	set the last link), but branch->key contains the number that should
  *	be placed into *branch->p to fill that gap.
@@ -662,7 +662,7 @@ static int ext2_get_blocks(struct inode *inode,
 	mutex_lock(&ei->truncate_mutex);
 	/*
 	 * If the indirect block is missing while we are reading
-	 * the chain(ext3_get_branch() returns -EAGAIN err), or
+	 * the chain(ext2_get_branch() returns -EAGAIN err), or
 	 * if the chain has been changed after we grab the semaphore,
 	 * (either because another process truncated this branch, or
 	 * another get_block allocated this branch) re-grab the chain to see if
-- 
1.7.2.2

