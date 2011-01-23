Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1AWERT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 23:17:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21703 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1AWERR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 23:17:17 -0500
Date: Sat, 22 Jan 2011 20:16:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH] fs: fix new dcache.c kernel-doc warnings
Message-Id: <20110122201606.79c63924.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new fs/dcache.c kernel-doc warnings:

Warning(fs/dcache.c:184): No description found for parameter 'dentry'
Warning(fs/dcache.c:296): No description found for parameter 'parent'
Warning(fs/dcache.c:1985): No description found for parameter 'dparent'
Warning(fs/dcache.c:1985): Excess function parameter 'parent' description in 'd_validate'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Alexander Viro <viro@zeniv.linux.org.uk>
Cc:	Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-2638-rc2.orig/fs/dcache.c
+++ lnx-2638-rc2/fs/dcache.c
@@ -176,6 +176,7 @@ static void d_free(struct dentry *dentry
 
 /**
  * dentry_rcuwalk_barrier - invalidate in-progress rcu-walk lookups
+ * @dentry: the target dentry
  * After this call, in-progress rcu-walk path lookup will fail. This
  * should be called after unhashing, and after changing d_inode (if
  * the dentry has not already been unhashed).
@@ -281,6 +282,7 @@ static void dentry_lru_move_tail(struct 
 /**
  * d_kill - kill dentry and return parent
  * @dentry: dentry to kill
+ * @parent: parent dentry
  *
  * The dentry must already be unhashed and removed from the LRU.
  *
@@ -1973,7 +1975,7 @@ out:
 /**
  * d_validate - verify dentry provided from insecure source (deprecated)
  * @dentry: The dentry alleged to be valid child of @dparent
- * @parent: The parent dentry (known to be valid)
+ * @dparent: The parent dentry (known to be valid)
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.
