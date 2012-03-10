Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2CJDJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:09:47 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:47273 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab2CJDJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:09:45 -0500
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 22:09:45 EST
Date: Sat, 10 Mar 2012 02:51:03 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/6] Squashfs: update comment removing reference to zlib
 only
Message-ID: <4f5ac197.crucH6qQdXvMD3Aa%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Comment was written when Squashfs only supported zlib compression.
This comment is now misleading given Squashfs supports other
compression algorithms.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/block.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index ed0eb2a..fb50652 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -83,7 +83,8 @@ static struct buffer_head *get_block_length(struct super_block *sb,
  * filesystem), otherwise the length is obtained from the first two bytes of
  * the metadata block.  A bit in the length field indicates if the block
  * is stored uncompressed in the filesystem (usually because compression
- * generated a larger block - this does occasionally happen with zlib).
+ * generated a larger block - this does occasionally happen with compression
+ * algorithms).
  */
 int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			int length, u64 *next_index, int srclength, int pages)
-- 
1.7.5.4

