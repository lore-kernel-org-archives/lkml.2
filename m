Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab2E0BIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab2E0BIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:42 -0400
Message-Id: <20120527010428.838383176@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:59 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kees Cook <keescook@chromium.org>
Subject: [ 36/94] docs: update HOWTO for 2.6.x -> 3.x versioning
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 591bfc6bf9e5e25e464fd4c87d64afd5135667c4 upstream.

The HOWTO document needed updating for the new kernel versioning. The
git URI for -next was updated as well.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/HOWTO |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

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
@@ -285,7 +285,7 @@ The file Documentation/stable_kernel_rul
 documents what kinds of changes are acceptable for the -stable tree, and
 how the release process works.
 
-2.6.x -git patches
+3.x -git patches
 ------------------
 These are daily snapshots of Linus' kernel tree which are managed in a
 git repository (hence the name.) These patches are usually released
@@ -317,13 +317,13 @@ revisions to it, and maintainers can mar
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


