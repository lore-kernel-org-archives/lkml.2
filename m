Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738Ab0HESbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:31:25 -0400
Received: from xenotime.net ([72.52.115.56]:41702 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758123Ab0HESbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:31:07 -0400
Date: Thu, 05 Aug 2010 11:23:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: matt mooney <mfm@muteddisk.com>
Subject: [PATCH 4/7] Documentation: update kbuild make examples#2 to reflect changes
Message-ID: <1281032591607@xenotime.net>
In-Reply-To: <12810325911230@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Update section 3.2 and 3.5 example, along with text in section 3.5
to reflect change.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 Documentation/kbuild/makefiles.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.35-rc3.orig/Documentation/kbuild/makefiles.txt
+++ linux-2.6.35-rc3/Documentation/kbuild/makefiles.txt
@@ -168,7 +168,7 @@ more details, with real examples.
 		#drivers/isdn/i4l/Makefile
 		# Makefile for the kernel ISDN subsystem and device drivers.
 		# Each configuration option enables a list of files.
-		obj-$(CONFIG_ISDN)             += isdn.o
+		obj-$(CONFIG_ISDN_I4L)         += isdn.o
 		obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
 
 --- 3.3 Loadable module goals - obj-m
@@ -245,12 +245,12 @@ more details, with real examples.
 	may contain both a built-in.o and a lib.a file.
 
 	Example:
-		#arch/i386/lib/Makefile
-		lib-y    := checksum.o delay.o
+		#arch/x86/lib/Makefile
+		lib-y    := delay.o
 
-	This will create a library lib.a based on checksum.o and delay.o.
-	For kbuild to actually recognize that there is a lib.a being built,
-	the directory shall be listed in libs-y.
+	This will create a library lib.a based on delay.o. For kbuild to
+	actually recognize that there is a lib.a being built, the directory
+	shall be listed in libs-y.
 	See also "6.3 List directories to visit when descending".
 
 	Use of lib-y is normally restricted to lib/ and arch/*/lib.


-- 

