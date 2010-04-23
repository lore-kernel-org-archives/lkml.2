Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0DWCVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:21:01 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:49489 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab0DWCU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:20:58 -0400
Message-ID: <4BD103CE.9050508@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 03:19:58 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/4] squashfs: add missing buffer free
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/super.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 07ceeb8..48b6f4a 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -354,6 +354,7 @@ static void squashfs_put_super(struct super_block *sb)
  		kfree(sbi->id_table);
  		kfree(sbi->fragment_index);
  		kfree(sbi->meta_index);
+		kfree(sbi->inode_lookup_table);
  		kfree(sb->s_fs_info);
  		sb->s_fs_info = NULL;
  	}
-- 
1.6.3.3

