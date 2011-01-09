Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1AIDrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:47:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58836 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1AIDrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:47:10 -0500
Date: Sat, 8 Jan 2011 19:37:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 2/6] fs: fix dcache.h kernel-doc notation
Message-Id: <20110108193720.6cdd5e75.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc notation warning in dcache.h:

Warning(include/linux/dcache.h:316): Excess function parameter 'Returns' description in '__d_rcu_to_refcount'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Nick Piggin <npiggin@kernel.dk>
---
 include/linux/dcache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx0107.orig/include/linux/dcache.h
+++ lnx0107/include/linux/dcache.h
@@ -307,7 +307,7 @@ extern struct dentry *__d_lookup_rcu(str
  * __d_rcu_to_refcount - take a refcount on dentry if sequence check is ok
  * @dentry: dentry to take a ref on
  * @seq: seqcount to verify against
- * @Returns: 0 on failure, else 1.
+ * Returns: 0 on failure, else 1.
  *
  * __d_rcu_to_refcount operates on a dentry,seq pair that was returned
  * by __d_lookup_rcu, to get a reference on an rcu-walk dentry.
