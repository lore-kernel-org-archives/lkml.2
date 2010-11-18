Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab0KRXE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:04:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34055 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab0KRXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:04:25 -0500
Date: Thu, 18 Nov 2010 15:02:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: fix kernel-doc for dcache::prepend_path
Message-Id: <20101118150249.459b40fe.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function kernel-doc warning for prepend_path():

Warning(fs/dcache.c:1924): missing initial short description on line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lnx-2637-r2g4-kerndoc.orig/fs/dcache.c
+++ lnx-2637-r2g4-kerndoc/fs/dcache.c
@@ -1921,8 +1921,7 @@ static int prepend_name(char **buffer, i
 }
 
 /**
- * Prepend path string to a buffer
- *
+ * prepend_path - Prepend path string to a buffer
  * @path: the dentry/vfsmount to report
  * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: pointer to the end of the buffer
