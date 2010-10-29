Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264Ab0J2R4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:56:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28785 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab0J2R4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:56:41 -0400
Date: Fri, 29 Oct 2010 10:54:56 -0700
From: Randy Dunlap <randy.dunlap@Oracle.Com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs/dcache: fix kernel-doc warnings
Message-Id: <20101029105456.1d819b6c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Warning(fs/dcache.c:1495): No description found for parameter 'parent'
Warning(fs/dcache.c:1495): Excess function parameter 'dparent' description in 'd_validate'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36-git13.orig/fs/dcache.c
+++ linux-2.6.36-git13/fs/dcache.c
@@ -1485,7 +1485,7 @@ out:
 /**
  * d_validate - verify dentry provided from insecure source
  * @dentry: The dentry alleged to be valid child of @dparent
- * @dparent: The parent dentry (known to be valid)
+ * @parent: The parent dentry (known to be valid)
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.
