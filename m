Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0ICNnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:43:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58605 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab0ICNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:41:58 -0400
Message-Id: <20100903134154.225056137@szeredi.hu>
References: <20100903134116.039612691@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Fri, 03 Sep 2010 15:41:20 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 4/6] vfs: export do_splice_direct() to modules
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
--- linux-2.6.orig/fs/splice.c	2010-08-13 16:07:00.000000000 +0200
+++ linux-2.6/fs/splice.c	2010-08-25 18:59:08.000000000 +0200
@@ -1307,6 +1307,7 @@ long do_splice_direct(struct file *in, l
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,

-- 
