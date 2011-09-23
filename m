Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1IWUvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:51:48 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:4184 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1IWUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:51:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1316811102!13044113!16
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext2/xattr_security.c: local functions should be static
Date: Fri, 23 Sep 2011 13:51:24 -0700
User-Agent: KMail/1.9.9
CC: <linux-ext4@vger.kernel.org>, <jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231351.24566.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the sparse noise:

warning: symbol 'ext2_initxattrs' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>

---

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index c922adc..ed1a5d5 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -46,7 +46,7 @@ ext2_xattr_security_set(struct dentry *dentry, const char *name,
 			      value, size, flags);
 }
 
-int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		    void *fs_info)
 {
 	const struct xattr *xattr;
