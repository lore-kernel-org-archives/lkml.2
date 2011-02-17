Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BQJhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:37:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35289 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1BQJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=N5qnzpUfi71ROZZOj8gzY99Yv4QsGxj6fTNShn1m7wVIPF3ZgG2iZPtoq4THnkQ1Oa
         vVa8jN/4C+Lv2ULFrAwtM0hcGoP1fF6MDqIDKAP4ahxZG8FCCEzljkjB/+Gbl/fPey1/
         hKMOAWt4k/iStt2OBxju07N87DH5fchKoEM6I=
MIME-Version: 1.0
Date: Thu, 17 Feb 2011 17:37:02 +0800
Message-ID: <AANLkTim1wWi_sguqfo4t7V-RDT1tT41fkFtTVksoJGw5@mail.gmail.com>
Subject: [PATCH] code cleanup on include/linux/fs.h
From: Steven Liu <lingjiujianke@gmail.com>
To: torvalds <torvalds@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>,
        dchinner <dchinner@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  all,

    Can this patch be fixed in,

     Cleanup the unsed code on  include/linux/fs.h.
     All filesystem using mount_bdev and mount_nodev
     to replace get_sb_bdev and get_sb_nodev.
     So rmmove the unused code.


 Signed-off-by: LiuQi <lingjiujianke@gmail.com.com>
---
 include/linux/fs.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd32159..53ad8e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1807,10 +1807,6 @@ extern struct dentry *mount_ns(struct
file_system_type *fs_type, int flags,
 extern struct dentry *mount_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern int get_sb_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt);
 extern struct dentry *mount_single(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
@@ -1821,10 +1817,6 @@ extern int get_sb_single(struct
file_system_type *fs_type,
 extern struct dentry *mount_nodev(struct file_system_type *fs_type,
 	int flags, void *data,
 	int (*fill_super)(struct super_block *, void *, int));
-extern int get_sb_nodev(struct file_system_type *fs_type,
-	int flags, void *data,
-	int (*fill_super)(struct super_block *, void *, int),
-	struct vfsmount *mnt);
 void generic_shutdown_super(struct super_block *sb);
 void kill_block_super(struct super_block *sb);
 void kill_anon_super(struct super_block *sb);
-- 
1.6.5.2




Best Regards


Steven Liu
