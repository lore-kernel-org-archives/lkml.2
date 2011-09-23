Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1IWXAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:00:32 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:27057 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1IWXAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:00:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1316818824!32323295!15
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] jfs/xattr.c: local functions should be static
Date: Fri, 23 Sep 2011 16:00:17 -0700
User-Agent: KMail/1.9.9
CC: <jfs-discussion@lists.sourceforge.net>, <shaggy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231600.18033.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiets the sparse noise:

warning: symbol 'jfs_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dave Kleikamp <shaggy@kernel.org>

---

diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 26683e1..c52b16d 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -1089,7 +1089,7 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 }
 
 #ifdef CONFIG_JFS_SECURITY
-int jfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int jfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		   void *fs_info)
 {
 	const struct xattr *xattr;
