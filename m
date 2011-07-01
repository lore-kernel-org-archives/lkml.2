Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1GAK4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:56:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27710 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1GAK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:56:12 -0400
Date: Fri, 1 Jul 2011 12:46:56 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Update version number references in README
Message-ID: <alpine.LNX.2.00.1107011244300.9025@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 3.0 is released I believe the README should reflect the new
numbering.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 README |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/README b/README
index 8510017..0d5a7dd 100644
--- a/README
+++ b/README
@@ -1,6 +1,6 @@
-	Linux kernel release 2.6.xx <http://kernel.org/>
+	Linux kernel release 3.x <http://kernel.org/>
 
-These are the release notes for Linux version 2.6.  Read them carefully,
+These are the release notes for Linux version 3.  Read them carefully,
 as they tell you what this is all about, explain how to install the
 kernel, and what to do if something goes wrong. 
 
@@ -62,10 +62,10 @@ INSTALLING the kernel source:
    directory where you have permissions (eg. your home directory) and
    unpack it:
 
-		gzip -cd linux-2.6.XX.tar.gz | tar xvf -
+		gzip -cd linux-3.X.tar.gz | tar xvf -
 
    or
-		bzip2 -dc linux-2.6.XX.tar.bz2 | tar xvf -
+		bzip2 -dc linux-3.X.tar.bz2 | tar xvf -
 
 
    Replace "XX" with the version number of the latest kernel.
@@ -75,15 +75,15 @@ INSTALLING the kernel source:
    files.  They should match the library, and not get messed up by
    whatever the kernel-du-jour happens to be.
 
- - You can also upgrade between 2.6.xx releases by patching.  Patches are
+ - You can also upgrade between 3.x releases by patching.  Patches are
    distributed in the traditional gzip and the newer bzip2 format.  To
    install by patching, get all the newer patch files, enter the
-   top level directory of the kernel source (linux-2.6.xx) and execute:
+   top level directory of the kernel source (linux-3.x) and execute:
 
-		gzip -cd ../patch-2.6.xx.gz | patch -p1
+		gzip -cd ../patch-3.x.gz | patch -p1
 
    or
-		bzip2 -dc ../patch-2.6.xx.bz2 | patch -p1
+		bzip2 -dc ../patch-3.x.bz2 | patch -p1
 
    (repeat xx for all versions bigger than the version of your current
    source tree, _in_order_) and you should be ok.  You may want to remove
@@ -91,9 +91,9 @@ INSTALLING the kernel source:
    failed patches (xxx# or xxx.rej). If there are, either you or me has
    made a mistake.
 
-   Unlike patches for the 2.6.x kernels, patches for the 2.6.x.y kernels
+   Unlike patches for the 3.x kernels, patches for the 3.x.y kernels
    (also known as the -stable kernels) are not incremental but instead apply
-   directly to the base 2.6.x kernel.  Please read
+   directly to the base 3.x kernel.  Please read
    Documentation/applying-patches.txt for more information.
 
    Alternatively, the script patch-kernel can be used to automate this
@@ -107,14 +107,14 @@ INSTALLING the kernel source:
    an alternative directory can be specified as the second argument.
 
  - If you are upgrading between releases using the stable series patches
-   (for example, patch-2.6.xx.y), note that these "dot-releases" are
-   not incremental and must be applied to the 2.6.xx base tree. For
-   example, if your base kernel is 2.6.12 and you want to apply the
-   2.6.12.3 patch, you do not and indeed must not first apply the
-   2.6.12.1 and 2.6.12.2 patches. Similarly, if you are running kernel
-   version 2.6.12.2 and want to jump to 2.6.12.3, you must first
-   reverse the 2.6.12.2 patch (that is, patch -R) _before_ applying
-   the 2.6.12.3 patch.
+   (for example, patch-3.x.y), note that these "dot-releases" are
+   not incremental and must be applied to the 3.x base tree. For
+   example, if your base kernel is 3.0 and you want to apply the
+   3.0.3 patch, you do not and indeed must not first apply the
+   3.0.1 and 3.0.2 patches. Similarly, if you are running kernel
+   version 3.0.2 and want to jump to 3.0.3, you must first
+   reverse the 3.0.2 patch (that is, patch -R) _before_ applying
+   the 3.0.3 patch.
    You can read more on this in Documentation/applying-patches.txt
 
  - Make sure you have no stale .o files and dependencies lying around:
@@ -126,7 +126,7 @@ INSTALLING the kernel source:
 
 SOFTWARE REQUIREMENTS
 
-   Compiling and running the 2.6.xx kernels requires up-to-date
+   Compiling and running the 3.x kernels requires up-to-date
    versions of various software packages.  Consult
    Documentation/Changes for the minimum version numbers required
    and how to get updates for these packages.  Beware that using
@@ -142,11 +142,11 @@ BUILD directory for the kernel:
    Using the option "make O=output/dir" allow you to specify an alternate
    place for the output files (including .config).
    Example:
-     kernel source code:	/usr/src/linux-2.6.N
+     kernel source code:	/usr/src/linux-3.N
      build directory:		/home/name/build/kernel
 
    To configure and build the kernel use:
-   cd /usr/src/linux-2.6.N
+   cd /usr/src/linux-3.N
    make O=/home/name/build/kernel menuconfig
    make O=/home/name/build/kernel
    sudo make O=/home/name/build/kernel modules_install install
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

