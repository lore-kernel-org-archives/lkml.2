Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161793Ab2COVBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032291Ab2COVBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:01:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 38/38] Delete all instances of asm/system.h [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>
Date: Thu, 15 Mar 2012 21:01:09 +0000
Message-ID: <20120315210108.28759.15425.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete all instances of asm/system.h as they should be redundant by this
point.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/include/asm/system.h      |    5 -----
 arch/avr32/include/asm/system.h      |    6 ------
 arch/blackfin/include/asm/system.h   |    5 -----
 arch/c6x/include/asm/system.h        |    6 ------
 arch/cris/include/asm/system.h       |    5 -----
 arch/frv/include/asm/system.h        |    4 ----
 arch/h8300/include/asm/system.h      |    5 -----
 arch/hexagon/include/asm/system.h    |    5 -----
 arch/ia64/include/asm/system.h       |    4 ----
 arch/m32r/include/asm/system.h       |    6 ------
 arch/m68k/include/asm/system.h       |    5 -----
 arch/microblaze/include/asm/system.h |    6 ------
 arch/mips/include/asm/system.h       |    5 -----
 arch/mn10300/include/asm/system.h    |    5 -----
 arch/openrisc/include/asm/system.h   |    5 -----
 arch/parisc/include/asm/system.h     |    6 ------
 arch/powerpc/include/asm/system.h    |    6 ------
 arch/s390/include/asm/system.h       |    7 -------
 arch/score/include/asm/system.h      |    5 -----
 arch/sh/include/asm/system.h         |    8 --------
 arch/sparc/include/asm/system.h      |    6 ------
 arch/tile/include/asm/system.h       |    4 ----
 arch/unicore32/include/asm/system.h  |    7 -------
 arch/x86/include/asm/system.h        |    6 ------
 arch/xtensa/include/asm/system.h     |    5 -----
 include/asm-generic/system.h         |    5 -----
 26 files changed, 0 insertions(+), 142 deletions(-)
 delete mode 100644 arch/alpha/include/asm/system.h
 delete mode 100644 arch/avr32/include/asm/system.h
 delete mode 100644 arch/blackfin/include/asm/system.h
 delete mode 100644 arch/c6x/include/asm/system.h
 delete mode 100644 arch/cris/include/asm/system.h
 delete mode 100644 arch/frv/include/asm/system.h
 delete mode 100644 arch/h8300/include/asm/system.h
 delete mode 100644 arch/hexagon/include/asm/system.h
 delete mode 100644 arch/ia64/include/asm/system.h
 delete mode 100644 arch/m32r/include/asm/system.h
 delete mode 100644 arch/m68k/include/asm/system.h
 delete mode 100644 arch/microblaze/include/asm/system.h
 delete mode 100644 arch/mips/include/asm/system.h
 delete mode 100644 arch/mn10300/include/asm/system.h
 delete mode 100644 arch/openrisc/include/asm/system.h
 delete mode 100644 arch/parisc/include/asm/system.h
 delete mode 100644 arch/powerpc/include/asm/system.h
 delete mode 100644 arch/s390/include/asm/system.h
 delete mode 100644 arch/score/include/asm/system.h
 delete mode 100644 arch/sh/include/asm/system.h
 delete mode 100644 arch/sparc/include/asm/system.h
 delete mode 100644 arch/tile/include/asm/system.h
 delete mode 100644 arch/unicore32/include/asm/system.h
 delete mode 100644 arch/x86/include/asm/system.h
 delete mode 100644 arch/xtensa/include/asm/system.h
 delete mode 100644 include/asm-generic/system.h

diff --git a/arch/alpha/include/asm/system.h b/arch/alpha/include/asm/system.h
deleted file mode 100644
index c7270dc..0000000
--- a/arch/alpha/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/exec.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/avr32/include/asm/system.h b/arch/avr32/include/asm/system.h
deleted file mode 100644
index 0d84f9e..0000000
--- a/arch/avr32/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/blackfin/include/asm/system.h b/arch/blackfin/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/blackfin/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/c6x/include/asm/system.h b/arch/c6x/include/asm/system.h
deleted file mode 100644
index 0d84f9e..0000000
--- a/arch/c6x/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/cris/include/asm/system.h b/arch/cris/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/cris/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
deleted file mode 100644
index 659bcdb..0000000
--- a/arch/frv/include/asm/system.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/h8300/include/asm/system.h b/arch/h8300/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/h8300/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/hexagon/include/asm/system.h b/arch/hexagon/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/hexagon/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
deleted file mode 100644
index 5b190b4..0000000
--- a/arch/ia64/include/asm/system.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/m32r/include/asm/system.h b/arch/m32r/include/asm/system.h
deleted file mode 100644
index a55c384..0000000
--- a/arch/m32r/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/dcache_clear.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/m68k/include/asm/system.h b/arch/m68k/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/m68k/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
deleted file mode 100644
index 0d84f9e..0000000
--- a/arch/microblaze/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/mips/include/asm/system.h b/arch/mips/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/mips/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/mn10300/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/openrisc/include/asm/system.h b/arch/openrisc/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/openrisc/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/parisc/include/asm/system.h b/arch/parisc/include/asm/system.h
deleted file mode 100644
index fc2c126..0000000
--- a/arch/parisc/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/exec.h>
-#include <asm/ldcw.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
deleted file mode 100644
index 502c1e0..0000000
--- a/arch/powerpc/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/debug.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
deleted file mode 100644
index 641c729..0000000
--- a/arch/s390/include/asm/system.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/ctl_reg.h>
-#include <asm/exec.h>
-#include <asm/facility.h>
-#include <asm/switch_to.h>
diff --git a/arch/score/include/asm/system.h b/arch/score/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/score/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
deleted file mode 100644
index 04268aa..0000000
--- a/arch/sh/include/asm/system.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/bl_bit.h>
-#include <asm/cache_insns.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
-#include <asm/traps.h>
diff --git a/arch/sparc/include/asm/system.h b/arch/sparc/include/asm/system.h
deleted file mode 100644
index ed532ba..0000000
--- a/arch/sparc/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cpu_type.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
deleted file mode 100644
index 5b190b4..0000000
--- a/arch/tile/include/asm/system.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/arch/unicore32/include/asm/system.h b/arch/unicore32/include/asm/system.h
deleted file mode 100644
index cfc1498..0000000
--- a/arch/unicore32/include/asm/system.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/cr.h>
-#include <asm/exec.h>
-#include <asm/setup.h>
-#include <asm/switch_to.h>
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
deleted file mode 100644
index 0d84f9e..0000000
--- a/arch/x86/include/asm/system.h
+++ /dev/null
@@ -1,6 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/special_insns.h>
-#include <asm/switch_to.h>
diff --git a/arch/xtensa/include/asm/system.h b/arch/xtensa/include/asm/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/arch/xtensa/include/asm/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
deleted file mode 100644
index a7f4057..0000000
--- a/include/asm-generic/system.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/exec.h>
-#include <asm/switch_to.h>

