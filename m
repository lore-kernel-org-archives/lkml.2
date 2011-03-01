Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1CAMhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:37:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57933 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1CAMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:37:05 -0500
Message-Id: <20110301123701.955702964@szeredi.hu>
References: <20110301123645.189703316@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 01 Mar 2011 13:36:47 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: apw@canonical.com
Subject: [PATCH 2/6 v6] vfs: export do_splice_direct() to modules
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
--- linux-2.6.orig/fs/splice.c	2011-02-22 11:04:39.000000000 +0100
+++ linux-2.6/fs/splice.c	2011-03-01 12:18:16.000000000 +0100
@@ -1296,6 +1296,7 @@ long do_splice_direct(struct file *in, l
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,

-- 
