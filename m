Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab0HESbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:12 -0400
Received: from xenotime.net ([72.52.115.56]:39937 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758656Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH 6/7] Documentation: fix kbuild typos and wording
Message-ID: <12810325911232@xenotime.net>
In-Reply-To: <12810325911230@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>

Fixed some typos and wording.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 Documentation/kbuild/kbuild.txt    |    8 ++++----
 Documentation/kbuild/makefiles.txt |   24 ++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

--- linux-2.6.35-rc3.orig/Documentation/kbuild/kbuild.txt
+++ linux-2.6.35-rc3/Documentation/kbuild/kbuild.txt
@@ -40,15 +40,15 @@ Set the directory to look for the kernel
 modules.
 The directory can be specified in several ways:
 1) Use "M=..." on the command line
-2) Environmnet variable KBUILD_EXTMOD
-3) Environmnet variable SUBDIRS
+2) Environment variable KBUILD_EXTMOD
+3) Environment variable SUBDIRS
 The possibilities are listed in the order they take precedence.
 Using "M=..." will always override the others.
 
 KBUILD_OUTPUT
 --------------------------------------------------
 Specify the output directory when building the kernel.
-The output directory can also be specificed using "O=...".
+The output directory can also be specified using "O=...".
 Setting "O=..." takes precedence over KBUILD_OUTPUT.
 
 ARCH
@@ -90,7 +90,7 @@ The script will be called with the follo
     $3 - kernel map file
     $4 - default install path (use root directory if blank)
 
-The implmentation of "make install" is architecture specific
+The implementation of "make install" is architecture specific
 and it may differ from the above.
 
 INSTALLKERNEL is provided to enable the possibility to
--- linux-2.6.35-rc3.orig/Documentation/kbuild/makefiles.txt
+++ linux-2.6.35-rc3/Documentation/kbuild/makefiles.txt
@@ -285,12 +285,12 @@ more details, with real examples.
 --- 3.7 Compilation flags
 
     ccflags-y, asflags-y and ldflags-y
-	The three flags listed above apply only to the kbuild makefile where
-	they are assigned (i.e., per-directory). They are used for all the
-	normal cc, as and ld invocation happening during a recursive build.
+	These three flags apply only to the kbuild makefile in which they
+	are assigned. They are used for all the normal cc, as and ld
+	invocations happening during a recursive build.
 	Note: Flags with the same behaviour were previously named:
-	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS. They are still
-	supported but their use is deprecated.
+	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
+	They are still supported but their usage is deprecated.
 
 	ccflags-y specifies options for compiling with $(CC).
 
@@ -317,10 +317,10 @@ more details, with real examples.
 
     subdir-ccflags-y, subdir-asflags-y
 	The two flags listed above are similar to ccflags-y and asflags-y.
-	The difference is that the subdir- variants affect the kbuild
-	file where they are present and all subdirectories. Options specified
-	using subdir-* are added to the commandline before the options
-	specified using the non-subdir variants.
+	The difference is that the subdir- variants have effect for the kbuild
+	file where they are present and all subdirectories.
+	Options specified using subdir-* are added to the commandline before
+	the options specified using the non-subdir variants.
 
 	Example:
 		subdir-ccflags-y := -Werror
@@ -1174,14 +1174,14 @@ When kbuild executes, the following step
 === 7 Kbuild syntax for exported headers
 
 The kernel include a set of headers that is exported to userspace.
-Many headers can be exported as-is but other headers requires  a
+Many headers can be exported as-is but other headers require a
 minimal pre-processing before they are ready for user-space.
 The pre-processing does:
 - drop kernel specific annotations
 - drop include of compiler.h
-- drop all sections that is kernel internat (guarded by ifdef __KERNEL__)
+- drop all sections that are kernel internal (guarded by ifdef __KERNEL__)
 
-Each relevant directory contain a file name "Kbuild" which specify the
+Each relevant directory contains a file name "Kbuild" which specifies the
 headers to be exported.
 See subsequent chapter for the syntax of the Kbuild file.
 


-- 

