Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2CSEXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:23:09 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50138 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750938Ab2CSEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:23:07 -0400
Message-ID: <4F66B4A9.3040208@xenotime.net>
Date: Sun, 18 Mar 2012 21:23:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs: fix kernel-doc warnings in dcache.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in fs/dcache.c:

Warning(fs/dcache.c:1743): No description found for parameter 'seqp'
Warning(fs/dcache.c:1743): Excess function parameter 'seq' description in '__d_lookup_rcu'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33.orig/fs/dcache.c
+++ lnx-33/fs/dcache.c
@@ -1714,7 +1714,7 @@ EXPORT_SYMBOL(d_add_ci);
  * __d_lookup_rcu - search for a dentry (racy, store-free)
  * @parent: parent dentry
  * @name: qstr of name we wish to find
- * @seq: returns d_seq value at the point where the dentry was found
+ * @seqp: returns d_seq value at the point where the dentry was found
  * @inode: returns dentry->d_inode when the inode was found valid.
  * Returns: dentry, or NULL
  *
