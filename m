Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844Ab0HEWrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:47:09 -0400
Received: from kroah.org ([198.145.64.141]:37572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760776Ab0HEWXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Dike <jdike@addtoit.com>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 10/67] tty: remove remaining Hayes ESP ioctls
Date: Thu,  5 Aug 2010 15:22:37 -0700
Message-Id: <1281047014-23429-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Jeff Dike pointed out, the Hayes ESP driver was removed in commit
f53a2ade0bb9f2a81f473e6469155172a96b7c38, so these ioctl definitions
should also be removed.  This cleans up the remaining arch-specific
locations of this ioctl value.

Thanks to Arnd for pointing these out.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/alpha/include/asm/ioctls.h   |    2 --
 arch/avr32/include/asm/ioctls.h   |    2 --
 arch/cris/include/asm/ioctls.h    |    2 --
 arch/ia64/include/asm/ioctls.h    |    2 --
 arch/m32r/include/asm/ioctls.h    |    2 --
 arch/mips/include/asm/ioctls.h    |    2 --
 arch/mn10300/include/asm/ioctls.h |    2 --
 arch/parisc/include/asm/ioctls.h  |    2 --
 8 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/alpha/include/asm/ioctls.h b/arch/alpha/include/asm/ioctls.h
index 67bb9f6..c7b0cc6 100644
--- a/arch/alpha/include/asm/ioctls.h
+++ b/arch/alpha/include/asm/ioctls.h
@@ -106,7 +106,5 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
 
 #endif /* _ASM_ALPHA_IOCTLS_H */
diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
index e6ac0b6..143dafb 100644
--- a/arch/avr32/include/asm/ioctls.h
+++ b/arch/avr32/include/asm/ioctls.h
@@ -72,8 +72,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
 /* Used for packet mode */
diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 35bbc18..0c66ef6 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -70,8 +70,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
 #define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
diff --git a/arch/ia64/include/asm/ioctls.h b/arch/ia64/include/asm/ioctls.h
index f41b636..f0ee86c 100644
--- a/arch/ia64/include/asm/ioctls.h
+++ b/arch/ia64/include/asm/ioctls.h
@@ -75,8 +75,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
 /* Used for packet mode */
diff --git a/arch/m32r/include/asm/ioctls.h b/arch/m32r/include/asm/ioctls.h
index b9f54bb..f4c13a5 100644
--- a/arch/m32r/include/asm/ioctls.h
+++ b/arch/m32r/include/asm/ioctls.h
@@ -69,8 +69,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
 /* Used for packet mode */
diff --git a/arch/mips/include/asm/ioctls.h b/arch/mips/include/asm/ioctls.h
index 3f04a99..2fb9e16 100644
--- a/arch/mips/include/asm/ioctls.h
+++ b/arch/mips/include/asm/ioctls.h
@@ -103,7 +103,5 @@
 #define TIOCSERSETMULTI 0x5490 /* Set multiport config */
 #define TIOCMIWAIT      0x5491 /* wait for a change on serial input line(s) */
 #define TIOCGICOUNT     0x5492 /* read serial port inline interrupt counts */
-#define TIOCGHAYESESP	0x5493 /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP	0x5494 /* Set Hayes ESP configuration */
 
 #endif /* __ASM_IOCTLS_H */
diff --git a/arch/mn10300/include/asm/ioctls.h b/arch/mn10300/include/asm/ioctls.h
index dcbfb45..638219a 100644
--- a/arch/mn10300/include/asm/ioctls.h
+++ b/arch/mn10300/include/asm/ioctls.h
@@ -70,8 +70,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
 /* Used for packet mode */
diff --git a/arch/parisc/include/asm/ioctls.h b/arch/parisc/include/asm/ioctls.h
index 6747fad..6cc497e 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -68,8 +68,6 @@
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
-#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460	/* Get exact space used by quota */
 
 #define TIOCSTART	0x5461
-- 
1.7.2

