Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1FOUCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:02:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52503 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1FOUCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:02:32 -0400
Date: Wed, 15 Jun 2011 13:00:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Paul Menage <menage@google.com>,
        joerg@alea.gnuu.de
Subject: [PATCH 4/4] Documentation: fix cgroup typos and formatting
Message-Id: <20110615130047.a2b8ee9a.randy.dunlap@oracle.com>
In-Reply-To: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
References: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DF90FD4.002A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jörg Sommer <joerg@alea.gnuu.de>

Fix format and spelling.

Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/cgroups/blkio-controller.txt |    2 -
 Documentation/cgroups/cgroups.txt          |    2 -
 Documentation/cgroups/memory.txt           |   22 +++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

--- lnx-30-rc2.orig/Documentation/cgroups/blkio-controller.txt
+++ lnx-30-rc2/Documentation/cgroups/blkio-controller.txt
@@ -111,7 +111,7 @@ Hierarchical Cgroups
   CFQ and throttling will practically treat all groups at same level.
 
 				pivot
-			     /  |   \  \
+			     /  /   \  \
 			root  test1 test2  test3
 
   Down the line we can implement hierarchical accounting/control support
--- lnx-30-rc2.orig/Documentation/cgroups/cgroups.txt
+++ lnx-30-rc2/Documentation/cgroups/cgroups.txt
@@ -142,7 +142,7 @@ and depending on who is launching the br
 
 With only a single hierarchy, he now would potentially have to create
 a separate cgroup for every browser launched and associate it with
-approp network and other resource class.  This may lead to
+appropriate network and other resource class.  This may lead to
 proliferation of such cgroups.
 
 Also lets say that the administrator would like to give enhanced network
--- lnx-30-rc2.orig/Documentation/cgroups/memory.txt
+++ lnx-30-rc2/Documentation/cgroups/memory.txt
@@ -1,8 +1,8 @@
 Memory Resource Controller
 
-NOTE: The Memory Resource Controller has been generically been referred
-      to as the memory controller in this document. Do not confuse memory
-      controller used here with the memory controller that is used in hardware.
+NOTE: The Memory Resource Controller has generically been referred to as the
+      memory controller in this document. Do not confuse memory controller
+      used here with the memory controller that is used in hardware.
 
 (For editors)
 In this document:
@@ -181,7 +181,7 @@ behind this approach is that a cgroup th
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
-Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used..
+Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
@@ -213,7 +213,7 @@ affecting global LRU, memory+swap limit 
 OS point of view.
 
 * What happens when a cgroup hits memory.memsw.limit_in_bytes
-When a cgroup his memory.memsw.limit_in_bytes, it's useless to do swap-out
+When a cgroup hits memory.memsw.limit_in_bytes, it's useless to do swap-out
 in this cgroup. Then, swap-out will not be done by cgroup routine and file
 caches are dropped. But as mentioned above, global LRU can do swapout memory
 from it for sanity of the system's memory management state. You can't forbid
@@ -472,13 +472,13 @@ The hierarchy is created by creating the
 cgroup filesystem. Consider for example, the following cgroup filesystem
 hierarchy
 
-		root
+	       root
 	     /  |   \
-           /	|    \
-	  a	b	c
-			| \
-			|  \
-			d   e
+            /	|    \
+	   a	b     c
+		      | \
+		      |  \
+		      d   e
 
 In the diagram above, with hierarchical accounting enabled, all memory
 usage of e, is accounted to its ancestors up until the root (i.e, c and root),
