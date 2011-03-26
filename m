Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1CZU2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:28:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32628 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1CZU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:28:18 -0400
Date: Sat, 26 Mar 2011 13:27:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: [PATCH] mm: fix memory.c incorrect kernel-doc
Message-Id: <20110326132701.f0014b20.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D8E4C3A.0078,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mm/memory.c incorrect kernel-doc function notation:

Warning(mm/memory.c:3718): Cannot understand  * @access_remote_vm - access another process' address space
 on line 3718 - I thought it was a doc line

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-git18.orig/mm/memory.c
+++ linux-2.6.38-git18/mm/memory.c
@@ -3715,7 +3715,7 @@ static int __access_remote_vm(struct tas
 }
 
 /**
- * @access_remote_vm - access another process' address space
+ * access_remote_vm - access another process' address space
  * @mm:		the mm_struct of the target address space
  * @addr:	start address to access
  * @buf:	source or destination buffer
