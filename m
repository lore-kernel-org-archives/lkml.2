Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1CVPaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:30:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46975 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1CVPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:30:20 -0400
Message-Id: <20110322153015.922856251@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 22 Mar 2011 16:26:04 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Subject: [PATCH 2/6 v7] vfs: export do_splice_direct() to modules
Content-Disposition: inline; filename=vfs-export-do_splice_direct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Export do_splice_direct() to modules.  Needed by overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2011-03-22 15:11:27.000000000 +0100
+++ linux-2.6/fs/splice.c	2011-03-22 15:11:32.000000000 +0100
@@ -1296,6 +1296,7 @@ long do_splice_direct(struct file *in, l
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,

-- 
