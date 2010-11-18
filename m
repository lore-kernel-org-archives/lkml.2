Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab0KRXDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:03:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33370 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801Ab0KRXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:03:52 -0500
Date: Thu, 18 Nov 2010 15:02:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: fix kernel-doc for dcache::d_validate
Message-Id: <20101118150245.f85f9603.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter kernel-doc for d_validate():

Warning(fs/dcache.c:1495): No description found for parameter 'parent'
Warning(fs/dcache.c:1495): Excess function parameter 'dparent' description in 'd_validate'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2637-r2g4-kerndoc.orig/fs/dcache.c
+++ lnx-2637-r2g4-kerndoc/fs/dcache.c
@@ -1485,7 +1485,7 @@ out:
 /**
  * d_validate - verify dentry provided from insecure source
  * @dentry: The dentry alleged to be valid child of @dparent
- * @dparent: The parent dentry (known to be valid)
+ * @parent: The parent dentry (known to be valid)
  *
  * An insecure source has sent us a dentry, here we verify it and dget() it.
  * This is used by ncpfs in its readdir implementation.
