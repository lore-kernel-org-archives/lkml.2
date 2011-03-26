Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1CZU2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:28:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32623 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1CZU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:28:17 -0400
Date: Sat, 26 Mar 2011 13:27:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ipc: fix util.c kernel-doc warnings
Message-Id: <20110326132741.c7ccbe87.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D8E4C3F.00B8,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ipc/util.c kernel-doc warnings:

Warning(ipc/util.c:336): No description found for parameter 'ns'
Warning(ipc/util.c:620): No description found for parameter 'ns'
Warning(ipc/util.c:790): No description found for parameter 'ns'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 ipc/util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.38-git18.orig/ipc/util.c
+++ linux-2.6.38-git18/ipc/util.c
@@ -317,6 +317,7 @@ retry:
 
 /**
  *	ipc_check_perms	-	check security and permissions for an IPC
+ *	@ns: IPC namespace
  *	@ipcp: ipc permission set
  *	@ops: the actual security routine to call
  *	@params: its parameters
@@ -607,6 +608,7 @@ void ipc_rcu_putref(void *ptr)
 
 /**
  *	ipcperms	-	check IPC permissions
+ *	@ns: IPC namespace
  *	@ipcp: IPC permission set
  *	@flag: desired permission set.
  *
@@ -769,7 +771,7 @@ void ipc_update_perm(struct ipc64_perm *
 
 /**
  * ipcctl_pre_down - retrieve an ipc and check permissions for some IPC_XXX cmd
- * @ids:  the ipc namespace
+ * @ns:  the ipc namespace
  * @ids:  the table of ids where to look for the ipc
  * @id:   the id of the ipc to retrieve
  * @cmd:  the cmd to check
