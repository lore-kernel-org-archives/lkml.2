Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0HNUHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 16:07:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29068 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab0HNUHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 16:07:41 -0400
Date: Sat, 14 Aug 2010 13:05:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] fs/dcache: fix function param name in kernel-doc
Message-Id: <20100814130531.f146a1a7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix parameter name in kernel-doc notation (causes a warning).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git15.orig/fs/dcache.c
+++ linux-2.6.35-git15/fs/dcache.c
@@ -1976,7 +1976,7 @@ global_root:
  * __d_path - return the path of a dentry
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
- * @buffer: buffer to return value in
+ * @buf: buffer to return value in
  * @buflen: buffer length
  *
  * Convert a dentry into an ASCII path name.
