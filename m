Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0FZNCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 09:02:07 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:46434 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab0FZNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 09:02:05 -0400
Date: Sat, 26 Jun 2010 15:00:21 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] Documentation/kbuild: fixed typos and wording
Message-ID: <20100626150021.254b95b3@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some typos and wording.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 Documentation/kbuild/kbuild.txt    |    8 ++++----
 Documentation/kbuild/makefiles.txt |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 634c625..0d8addb 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -40,15 +40,15 @@ Set the directory to look for the kernel source when building external
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
@@ -90,7 +90,7 @@ The script will be called with the following arguments:
     $3 - kernel map file
     $4 - default install path (use root directory if blank)
 
-The implmentation of "make install" is architecture specific
+The implementation of "make install" is architecture specific
 and it may differ from the above.
 
 INSTALLKERNEL is provided to enable the possibility to
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 71c602d..c0c9b1c 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -284,12 +284,12 @@ more details, with real examples.
 --- 3.7 Compilation flags
 
     ccflags-y, asflags-y and ldflags-y
-	The three flags listed above applies only to the kbuild makefile
-	where they are assigned. They are used for all the normal
-	cc, as and ld invocation happenign during a recursive build.
+	These three flags apply only to the kbuild makefile in which they
+	are assigned. They are used for all the normal cc, as and ld
+	invocations happening during a recursive build.
 	Note: Flags with the same behaviour were previously named:
 	EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
-	They are yet supported but their use are deprecated.
+	They are still supported but their usage is deprecated.
 
 	ccflags-y specifies options for compiling C files with $(CC).
 
@@ -318,9 +318,9 @@ more details, with real examples.
 		ldflags-y := -x
 
     subdir-ccflags-y, subdir-asflags-y
-	The two flags listed above are similar to ccflags-y and as-falgs-y.
-	The difference is that the subdir- variants has effect for the kbuild
-	file where tey are present and all subdirectories.
+	The two flags listed above are similar to ccflags-y and as-flags-y.
+	The difference is that the subdir- variants have effect for the kbuild
+	file where they are present and all subdirectories.
 	Options specified using subdir-* are added to the commandline before
 	the options specified using the non-subdir variants.
 
@@ -1176,14 +1176,14 @@ When kbuild executes, the following steps are followed (roughly):
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
1.7.1
