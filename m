Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0IJBjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:39:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40736 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0IJBjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=PlYfLZY4rLgnzE715gSB0FuuYOtYqCAoguictpjpBxWubR6mIlRBrG3pDBkODmorXi
         qStrFckAj9YFmeAPQNFaJyoGkyfbGKyq+0Erhm/WEa0TPXl090jzJqG4jwaXnvi+EmyP
         puSAPnx7OnIPZoh/G5D8Hk8Zr78OMKC7baDf8=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED] ext2: trivial: fix typo on comments in ext2/inode.c
References: <1283962489-15842-1-git-send-email-namhyung@gmail.com>
Date: Fri, 10 Sep 2010 10:39:29 +0900
In-Reply-To: <1283962489-15842-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Thu, 9 Sep 2010 01:14:49 +0900")
Message-ID: <87eid2peb2.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'excpet' should be 'except'.
'ext3_get_branch' should be 'ext2_get_branch'.
    
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
I found another one.

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 940c961..533699c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -458,7 +458,7 @@ failed_out:
  *     the same format as ext2_get_branch() would do. We are calling it after
  *     we had read the existing part of chain and partial points to the last
  *     triple of that (one with zero ->key). Upon the exit we have the same
- *     picture as after the successful ext2_get_block(), excpet that in one
+ *     picture as after the successful ext2_get_block(), except that in one
  *     place chain is disconnected - *branch->p is still zero (we did not
  *     set the last link), but branch->key contains the number that should
  *     be placed into *branch->p to fill that gap.
@@ -662,7 +662,7 @@ static int ext2_get_blocks(struct inode *inode,
        mutex_lock(&ei->truncate_mutex);
        /*
         * If the indirect block is missing while we are reading
-        * the chain(ext3_get_branch() returns -EAGAIN err), or
+        * the chain(ext2_get_branch() returns -EAGAIN err), or
         * if the chain has been changed after we grab the semaphore,
         * (either because another process truncated this branch, or
         * another get_block allocated this branch) re-grab the chain to see if
-- 
1.7.2.2

