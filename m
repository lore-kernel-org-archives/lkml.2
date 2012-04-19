Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2DSGQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:16:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32800 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2DSGQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:16:48 -0400
Date: Wed, 18 Apr 2012 23:16:45 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH] docs: update HOWTO for 2.6.x -> 3.x versioning
Message-ID: <20120419061645.GA25127@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HOWTO document needed updating for the new kernel versioning. The
git URI for -next was updated as well.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/HOWTO |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index f7ade3b..59c080f 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -218,16 +218,16 @@ The development process
 Linux kernel development process currently consists of a few different
 main kernel "branches" and lots of different subsystem-specific kernel
 branches.  These different branches are:
-  - main 2.6.x kernel tree
-  - 2.6.x.y -stable kernel tree
-  - 2.6.x -git kernel patches
+  - main 3.x kernel tree
+  - 3.x.y -stable kernel tree
+  - 3.x -git kernel patches
   - subsystem specific kernel trees and patches
-  - the 2.6.x -next kernel tree for integration tests
+  - the 3.x -next kernel tree for integration tests
 
-2.6.x kernel tree
+3.x kernel tree
 -----------------
-2.6.x kernels are maintained by Linus Torvalds, and can be found on
-kernel.org in the pub/linux/kernel/v2.6/ directory.  Its development
+3.x kernels are maintained by Linus Torvalds, and can be found on
+kernel.org in the pub/linux/kernel/v3.x/ directory.  Its development
 process is as follows:
   - As soon as a new kernel is released a two weeks window is open,
     during this period of time maintainers can submit big diffs to
@@ -262,20 +262,20 @@ mailing list about kernel releases:
 	released according to perceived bug status, not according to a
 	preconceived timeline."
 
-2.6.x.y -stable kernel tree
+3.x.y -stable kernel tree
 ---------------------------
-Kernels with 4-part versions are -stable kernels. They contain
+Kernels with 3-part versions are -stable kernels. They contain
 relatively small and critical fixes for security problems or significant
-regressions discovered in a given 2.6.x kernel.
+regressions discovered in a given 3.x kernel.
 
 This is the recommended branch for users who want the most recent stable
 kernel and are not interested in helping test development/experimental
 versions.
 
-If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
+If no 3.x.y kernel is available, then the highest numbered 3.x
 kernel is the current stable kernel.
 
-2.6.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
+3.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
 are released as needs dictate.  The normal release period is approximately
 two weeks, but it can be longer if there are no pressing problems.  A
 security-related problem, instead, can cause a release to happen almost
@@ -285,7 +285,7 @@ The file Documentation/stable_kernel_rules.txt in the kernel tree
 documents what kinds of changes are acceptable for the -stable tree, and
 how the release process works.
 
-2.6.x -git patches
+3.x -git patches
 ------------------
 These are daily snapshots of Linus' kernel tree which are managed in a
 git repository (hence the name.) These patches are usually released
@@ -317,13 +317,13 @@ revisions to it, and maintainers can mark patches as under review,
 accepted, or rejected.  Most of these patchwork sites are listed at
 http://patchwork.kernel.org/.
 
-2.6.x -next kernel tree for integration tests
+3.x -next kernel tree for integration tests
 ---------------------------------------------
-Before updates from subsystem trees are merged into the mainline 2.6.x
+Before updates from subsystem trees are merged into the mainline 3.x
 tree, they need to be integration-tested.  For this purpose, a special
 testing repository exists into which virtually all subsystem trees are
 pulled on an almost daily basis:
-	http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git
+	http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git
 	http://linux.f-seidel.de/linux-next/pmwiki/
 
 This way, the -next kernel gives a summary outlook onto what will be
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
