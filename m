Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab1LQXGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 18:06:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23279 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1LQXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 18:06:29 -0500
Date: Sun, 18 Dec 2011 00:06:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Mason <chris.mason@oracle.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH][TRIVIAL] btrfs: Remove a couple of redundant semi-colons
Message-ID: <alpine.LNX.2.00.1112180003140.21784@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/free-space-cache.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f44b392..2a8038a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2699,7 +2699,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	 * one reference for us, and we leave it for the
 	 * caller
 	 */
-	device->flush_bio = NULL;;
+	device->flush_bio = NULL;
 	bio = bio_alloc(GFP_NOFS, 0);
 	if (!bio)
 		return -ENOMEM;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..9a897bf 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -423,7 +423,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	}
 
 	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;;
+		offset = sizeof(u32) * io_ctl->num_pages;
 
 	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
-- 
1.7.8


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

