Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0EXAIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:08:14 -0400
Received: from xenotime.net ([72.52.115.56]:36552 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755709Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/9] Documentation/development-process: add staging & mmotm info
Message-ID: <12746593503909@xenotime.net>
In-Reply-To: <12746593501290@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update explanation of mmotm.
Add explanation of drivers/staging/.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/2.Process |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- lnx-2634-docs.orig/Documentation/development-process/2.Process
+++ lnx-2634-docs/Documentation/development-process/2.Process
@@ -267,12 +267,8 @@ an appropriate subsystem tree or be sent
 development cycle, approximately 10% of the patches going into the mainline
 get there via -mm.
 
-The current -mm patch can always be found from the front page of
-
-	http://kernel.org/
-
-Those who want to see the current state of -mm can get the "-mm of the
-moment" tree, found at:
+The current -mm patch is available in the "mmotm" (-mm of the moment)
+directory at:
 
 	http://userweb.kernel.org/~akpm/mmotm/
 
@@ -307,6 +303,12 @@ volatility of linux-next tends to make i
 See http://lwn.net/Articles/289013/ for more information on this topic, and
 stay tuned; much is still in flux where linux-next is involved.
 
+Besides the mmotm and linux-next trees, the kernel source tree now contains
+the drivers/staging/ directory and many sub-directories for drivers or
+filesystems that are on their way to being added to the kernel tree
+proper, but they remain in drivers/staging/ while they still need more
+work.
+
 
 2.5: TOOLS
 


-- 

