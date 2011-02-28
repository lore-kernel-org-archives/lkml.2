Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1B1XnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:43:03 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:53723 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab1B1XnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:43:00 -0500
Message-ID: <4D6C3311.6090304@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:43:13 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] Squashfs: wrap squashfs_mount() definition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Squashfs_get_sb() to squashfs_mount() conversion (commit 152a0836)
results in line over 80 characters.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/super.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 95467db..5c8184c 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -373,8 +373,8 @@ static void squashfs_put_super(struct super_block *sb)
  }


-static struct dentry *squashfs_mount(struct file_system_type *fs_type, int flags,
-				const char *dev_name, void *data)
+static struct dentry *squashfs_mount(struct file_system_type *fs_type,
+				int flags, const char *dev_name, void *data)
  {
  	return mount_bdev(fs_type, flags, dev_name, data, squashfs_fill_super);
  }
-- 
1.7.1

