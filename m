Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2BZXHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:07:01 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22200 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2BZXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:06:59 -0500
Date: Mon, 27 Feb 2012 00:04:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Mason <chris.mason@oracle.com>
cc: trivial@kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH][trivial] btrfs: assignment in write_dev_flush() doesn't need
 two semi-colons
Message-ID: <alpine.LNX.2.00.1202270003380.6089@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 534266f..f87590b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2744,7 +2744,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	 * one reference for us, and we leave it for the
 	 * caller
 	 */
-	device->flush_bio = NULL;;
+	device->flush_bio = NULL;
 	bio = bio_alloc(GFP_NOFS, 0);
 	if (!bio)
 		return -ENOMEM;
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

