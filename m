Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0LaB52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 20:57:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0LaB51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 20:57:27 -0500
Date: Fri, 31 Dec 2010 12:57:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the trivial tree with the ext4 tree
Message-Id: <20101231125721.3c3f4604.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
fs/ext4/ext4.h between commit 673c610033a8202c037ecd068c7a235495acda17
("ext4: Move struct ext4_mount_options from ext4.h to super.c") from the
ext4 tree and commit b595076a180a56d1bb170e6eceda6eb9d76f4cd3
("tree-wide: fix comment/printk typos") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/ext4.h
index 2a73925,1f253a9..0000000
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@@ -561,7 -561,23 +561,7 @@@ struct ext4_new_group_data 
  #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
  #endif
  
- /* Max physical block we can addres w/o extents */
 -
 -/*
 - *  Mount options
 - */
 -struct ext4_mount_options {
 -	unsigned long s_mount_opt;
 -	uid_t s_resuid;
 -	gid_t s_resgid;
 -	unsigned long s_commit_interval;
 -	u32 s_min_batch_time, s_max_batch_time;
 -#ifdef CONFIG_QUOTA
 -	int s_jquota_fmt;
 -	char *s_qf_names[MAXQUOTAS];
 -#endif
 -};
 -
+ /* Max physical block we can address w/o extents */
  #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
  
  /*
