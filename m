Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2CJD2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:28:35 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:60902 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311Ab2CJD2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:28:02 -0500
Date: Sat, 10 Mar 2012 02:52:50 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/6] Squashfs: remove redundant length initialisation in
 squashfs_lookup
Message-ID: <4f5ac202.qu5BxX8Rrxr8palI%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 0682b38..f6e3108 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -144,7 +144,7 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct squashfs_dir_entry *dire;
 	u64 block = squashfs_i(dir)->start + msblk->directory_table;
 	int offset = squashfs_i(dir)->offset;
-	int err, length = 0, dir_count, size;
+	int err, length, dir_count, size;
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
 
-- 
1.7.5.4

