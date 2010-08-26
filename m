Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0HZSfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:35:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58053 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0HZSft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:35:49 -0400
Message-Id: <20100826183505.404713194@szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 20:33:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
Subject: [PATCH 4/5] vfs: export do_splice_direct() to modules
Content-Disposition: inline; filename=vfs-export-do_splice_direct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Export do_splice_direct() to modules.  Needed by hybrid union
filesystem.

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
