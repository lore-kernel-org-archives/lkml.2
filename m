Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1CZU23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:28:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32640 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1CZU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:28:27 -0400
Date: Sat, 26 Mar 2011 13:27:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: fix inode.c kernel-doc warning
Message-Id: <20110326132747.70d1cad6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D8E4C47.007E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix inode.c kernel-doc fatal error: 2 comment sections have the same name:

Error(fs/inode.c:1171): duplicate section name 'Note'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-git18.orig/fs/inode.c
+++ linux-2.6.38-git18/fs/inode.c
@@ -1167,7 +1167,7 @@ EXPORT_SYMBOL(igrab);
  * Note: I_NEW is not waited upon so you have to be very careful what you do
  * with the returned inode.  You probably should be using ilookup5() instead.
  *
- * Note: @test is called with the inode_hash_lock held, so can't sleep.
+ * Note2: @test is called with the inode_hash_lock held, so can't sleep.
  */
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
