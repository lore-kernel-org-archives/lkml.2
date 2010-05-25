Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0EYFXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:23:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0EYFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:22:59 -0400
Date: Mon, 24 May 2010 22:22:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] fs/super: fix kernel-doc warning
Message-Id: <20100524222234.c8c377a4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BFB5EA1.0180:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/super.c kernel-doc warning and function notation:
Warning(fs/super.c:957): No description found for parameter 'sb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-2634-g8-kerndoc.orig/fs/super.c
+++ lnx-2634-g8-kerndoc/fs/super.c
@@ -946,8 +946,8 @@ out:
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
 /**
- * freeze_super -- lock the filesystem and force it into a consistent state
- * @super: the super to lock
+ * freeze_super - lock the filesystem and force it into a consistent state
+ * @sb: the super to lock
  *
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
