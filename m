Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0EQX3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:29:05 -0400
Received: from xenotime.net ([72.52.115.56]:43550 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753780Ab0EQX3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:29:01 -0400
Date: Mon, 17 May 2010 16:21:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/10] Documentation/development-process: add maintainers and git info
Message-ID: <12741384712268@xenotime.net>
In-Reply-To: <12741384711166@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add info on maintainers and persistent posting.
Update git home page.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/2.Process        |   15 ++++++++---
 Documentation/development-process/7.AdvancedTopics |    2 -
 2 files changed, 13 insertions(+), 4 deletions(-)

--- lnx-2634-docs.orig/Documentation/development-process/2.Process
+++ lnx-2634-docs/Documentation/development-process/2.Process
@@ -151,7 +151,7 @@ The stages that a patch goes through are
    well.
 
  - Wider review.  When the patch is getting close to ready for mainline
-   inclusion, it will be accepted by a relevant subsystem maintainer -
+   inclusion, it should be accepted by a relevant subsystem maintainer -
    though this acceptance is not a guarantee that the patch will make it
    all the way to the mainline.  The patch will show up in the maintainer's
    subsystem tree and into the staging trees (described below).  When the
@@ -159,6 +159,15 @@ The stages that a patch goes through are
    the discovery of any problems resulting from the integration of this
    patch with work being done by others.
 
+-  Please note that most maintainers also have day jobs, so merging
+   your patch may not be their highest priority.  If your patch is
+   getting feedback about changes that are needed, you should either
+   make those changes or justify why they should not be made.  If your
+   patch has no review complaints but is not being merged by its
+   appropriate subsystem or driver maintainer, you should be persistent
+   in updating the patch to the current kernel so that it applies cleanly
+   and keep sending it for review and merging.
+
  - Merging into the mainline.  Eventually, a successful patch will be
    merged into the mainline repository managed by Linus Torvalds.  More
    comments and/or problems may surface at this time; it is important that
@@ -319,9 +328,9 @@ developers; even if they do not use it f
 to keep up with what other developers (and the mainline) are doing.
 
 Git is now packaged by almost all Linux distributions.  There is a home
-page at 
+page at:
 
-	http://git.or.cz/
+	http://git-scm.com/
 
 That page has pointers to documentation and tutorials.  One should be
 aware, in particular, of the Kernel Hacker's Guide to git, which has
--- lnx-2634-docs.orig/Documentation/development-process/7.AdvancedTopics
+++ lnx-2634-docs/Documentation/development-process/7.AdvancedTopics
@@ -25,7 +25,7 @@ long document in its own right.  Instead
 fits into the kernel development process in particular.  Developers who
 wish to come up to speed with git will find more information at:
 
-	http://git.or.cz/
+	http://git-scm.com/
 
 	http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
 


-- 

