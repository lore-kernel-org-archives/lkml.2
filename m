Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1FCVkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:40:13 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:8765 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1FCVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:40:12 -0400
Message-Id: <201106032140.p53LeAb6025696@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 3 Jun 2011 17:36:18 -0400
Subject: [PATCH] tile: use generic-y format for one-line asm-generic headers
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 03 Jun 2011 21:40:11.0084 (UTC) FILETIME=[D0A340C0:01CC2236]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us remove a lot of one-line wrapper header files.
See commit d8ecc5cd8e227bc318513b5306ae88a474b8886d for context.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/Kbuild              |   38 +++++++++++++++++++++++++++++
 arch/tile/include/asm/bug.h               |    1 -
 arch/tile/include/asm/bugs.h              |    1 -
 arch/tile/include/asm/cputime.h           |    1 -
 arch/tile/include/asm/device.h            |    1 -
 arch/tile/include/asm/div64.h             |    1 -
 arch/tile/include/asm/emergency-restart.h |    1 -
 arch/tile/include/asm/errno.h             |    1 -
 arch/tile/include/asm/fb.h                |    1 -
 arch/tile/include/asm/fcntl.h             |    1 -
 arch/tile/include/asm/ioctl.h             |    1 -
 arch/tile/include/asm/ioctls.h            |    1 -
 arch/tile/include/asm/ipc.h               |    1 -
 arch/tile/include/asm/ipcbuf.h            |    1 -
 arch/tile/include/asm/irq_regs.h          |    1 -
 arch/tile/include/asm/kdebug.h            |    1 -
 arch/tile/include/asm/local.h             |    1 -
 arch/tile/include/asm/module.h            |    1 -
 arch/tile/include/asm/msgbuf.h            |    1 -
 arch/tile/include/asm/mutex.h             |    1 -
 arch/tile/include/asm/param.h             |    1 -
 arch/tile/include/asm/parport.h           |    1 -
 arch/tile/include/asm/poll.h              |    1 -
 arch/tile/include/asm/posix_types.h       |    1 -
 arch/tile/include/asm/resource.h          |    1 -
 arch/tile/include/asm/scatterlist.h       |    1 -
 arch/tile/include/asm/sembuf.h            |    1 -
 arch/tile/include/asm/serial.h            |    1 -
 arch/tile/include/asm/shmbuf.h            |    1 -
 arch/tile/include/asm/shmparam.h          |    1 -
 arch/tile/include/asm/socket.h            |    1 -
 arch/tile/include/asm/sockios.h           |    1 -
 arch/tile/include/asm/statfs.h            |    1 -
 arch/tile/include/asm/termbits.h          |    1 -
 arch/tile/include/asm/termios.h           |    1 -
 arch/tile/include/asm/types.h             |    1 -
 arch/tile/include/asm/ucontext.h          |    1 -
 arch/tile/include/asm/xor.h               |    1 -
 38 files changed, 38 insertions(+), 37 deletions(-)
 delete mode 100644 arch/tile/include/asm/bug.h
 delete mode 100644 arch/tile/include/asm/bugs.h
 delete mode 100644 arch/tile/include/asm/cputime.h
 delete mode 100644 arch/tile/include/asm/device.h
 delete mode 100644 arch/tile/include/asm/div64.h
 delete mode 100644 arch/tile/include/asm/emergency-restart.h
 delete mode 100644 arch/tile/include/asm/errno.h
 delete mode 100644 arch/tile/include/asm/fb.h
 delete mode 100644 arch/tile/include/asm/fcntl.h
 delete mode 100644 arch/tile/include/asm/ioctl.h
 delete mode 100644 arch/tile/include/asm/ioctls.h
 delete mode 100644 arch/tile/include/asm/ipc.h
 delete mode 100644 arch/tile/include/asm/ipcbuf.h
 delete mode 100644 arch/tile/include/asm/irq_regs.h
 delete mode 100644 arch/tile/include/asm/kdebug.h
 delete mode 100644 arch/tile/include/asm/local.h
 delete mode 100644 arch/tile/include/asm/module.h
 delete mode 100644 arch/tile/include/asm/msgbuf.h
 delete mode 100644 arch/tile/include/asm/mutex.h
 delete mode 100644 arch/tile/include/asm/param.h
 delete mode 100644 arch/tile/include/asm/parport.h
 delete mode 100644 arch/tile/include/asm/poll.h
 delete mode 100644 arch/tile/include/asm/posix_types.h
 delete mode 100644 arch/tile/include/asm/resource.h
 delete mode 100644 arch/tile/include/asm/scatterlist.h
 delete mode 100644 arch/tile/include/asm/sembuf.h
 delete mode 100644 arch/tile/include/asm/serial.h
 delete mode 100644 arch/tile/include/asm/shmbuf.h
 delete mode 100644 arch/tile/include/asm/shmparam.h
 delete mode 100644 arch/tile/include/asm/socket.h
 delete mode 100644 arch/tile/include/asm/sockios.h
 delete mode 100644 arch/tile/include/asm/statfs.h
 delete mode 100644 arch/tile/include/asm/termbits.h
 delete mode 100644 arch/tile/include/asm/termios.h
 delete mode 100644 arch/tile/include/asm/types.h
 delete mode 100644 arch/tile/include/asm/ucontext.h
 delete mode 100644 arch/tile/include/asm/xor.h

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 849ab2f..aec60dc 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -2,3 +2,41 @@ include include/asm-generic/Kbuild.asm
 
 header-y += ucontext.h
 header-y += hardwall.h
+
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cputime.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipc.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += local.h
+generic-y += module.h
+generic-y += msgbuf.h
+generic-y += mutex.h
+generic-y += param.h
+generic-y += parport.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += serial.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += statfs.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += xor.h
diff --git a/arch/tile/include/asm/bug.h b/arch/tile/include/asm/bug.h
deleted file mode 100644
index b12fd89..0000000
--- a/arch/tile/include/asm/bug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bug.h>
diff --git a/arch/tile/include/asm/bugs.h b/arch/tile/include/asm/bugs.h
deleted file mode 100644
index 61791e1..0000000
--- a/arch/tile/include/asm/bugs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bugs.h>
diff --git a/arch/tile/include/asm/cputime.h b/arch/tile/include/asm/cputime.h
deleted file mode 100644
index 6d68ad7..0000000
--- a/arch/tile/include/asm/cputime.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/cputime.h>
diff --git a/arch/tile/include/asm/device.h b/arch/tile/include/asm/device.h
deleted file mode 100644
index f0a4c25..0000000
--- a/arch/tile/include/asm/device.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/device.h>
diff --git a/arch/tile/include/asm/div64.h b/arch/tile/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/tile/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/tile/include/asm/emergency-restart.h b/arch/tile/include/asm/emergency-restart.h
deleted file mode 100644
index 3711bd9..0000000
--- a/arch/tile/include/asm/emergency-restart.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/emergency-restart.h>
diff --git a/arch/tile/include/asm/errno.h b/arch/tile/include/asm/errno.h
deleted file mode 100644
index 4c82b50..0000000
--- a/arch/tile/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/errno.h>
diff --git a/arch/tile/include/asm/fb.h b/arch/tile/include/asm/fb.h
deleted file mode 100644
index 3a4988e..0000000
--- a/arch/tile/include/asm/fb.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fb.h>
diff --git a/arch/tile/include/asm/fcntl.h b/arch/tile/include/asm/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/arch/tile/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/arch/tile/include/asm/ioctl.h b/arch/tile/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/tile/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/tile/include/asm/ioctls.h b/arch/tile/include/asm/ioctls.h
deleted file mode 100644
index ec34c76..0000000
--- a/arch/tile/include/asm/ioctls.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctls.h>
diff --git a/arch/tile/include/asm/ipc.h b/arch/tile/include/asm/ipc.h
deleted file mode 100644
index a46e3d9..0000000
--- a/arch/tile/include/asm/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff --git a/arch/tile/include/asm/ipcbuf.h b/arch/tile/include/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51..0000000
--- a/arch/tile/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipcbuf.h>
diff --git a/arch/tile/include/asm/irq_regs.h b/arch/tile/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/tile/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/tile/include/asm/kdebug.h b/arch/tile/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/tile/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/tile/include/asm/local.h b/arch/tile/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/tile/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
deleted file mode 100644
index 1e4b79f..0000000
--- a/arch/tile/include/asm/module.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/module.h>
diff --git a/arch/tile/include/asm/msgbuf.h b/arch/tile/include/asm/msgbuf.h
deleted file mode 100644
index 809134c..0000000
--- a/arch/tile/include/asm/msgbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/msgbuf.h>
diff --git a/arch/tile/include/asm/mutex.h b/arch/tile/include/asm/mutex.h
deleted file mode 100644
index ff6101a..0000000
--- a/arch/tile/include/asm/mutex.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/mutex-dec.h>
diff --git a/arch/tile/include/asm/param.h b/arch/tile/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/tile/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/tile/include/asm/parport.h b/arch/tile/include/asm/parport.h
deleted file mode 100644
index cf252af..0000000
--- a/arch/tile/include/asm/parport.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/parport.h>
diff --git a/arch/tile/include/asm/poll.h b/arch/tile/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/tile/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/tile/include/asm/posix_types.h b/arch/tile/include/asm/posix_types.h
deleted file mode 100644
index 22cae62..0000000
--- a/arch/tile/include/asm/posix_types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/posix_types.h>
diff --git a/arch/tile/include/asm/resource.h b/arch/tile/include/asm/resource.h
deleted file mode 100644
index 04bc4db..0000000
--- a/arch/tile/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/resource.h>
diff --git a/arch/tile/include/asm/scatterlist.h b/arch/tile/include/asm/scatterlist.h
deleted file mode 100644
index 35d786f..0000000
--- a/arch/tile/include/asm/scatterlist.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/scatterlist.h>
diff --git a/arch/tile/include/asm/sembuf.h b/arch/tile/include/asm/sembuf.h
deleted file mode 100644
index 7673b83..0000000
--- a/arch/tile/include/asm/sembuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sembuf.h>
diff --git a/arch/tile/include/asm/serial.h b/arch/tile/include/asm/serial.h
deleted file mode 100644
index a0cb0ca..0000000
--- a/arch/tile/include/asm/serial.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/serial.h>
diff --git a/arch/tile/include/asm/shmbuf.h b/arch/tile/include/asm/shmbuf.h
deleted file mode 100644
index 83c05fc..0000000
--- a/arch/tile/include/asm/shmbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/shmbuf.h>
diff --git a/arch/tile/include/asm/shmparam.h b/arch/tile/include/asm/shmparam.h
deleted file mode 100644
index 93f30de..0000000
--- a/arch/tile/include/asm/shmparam.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/shmparam.h>
diff --git a/arch/tile/include/asm/socket.h b/arch/tile/include/asm/socket.h
deleted file mode 100644
index 6b71384..0000000
--- a/arch/tile/include/asm/socket.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/socket.h>
diff --git a/arch/tile/include/asm/sockios.h b/arch/tile/include/asm/sockios.h
deleted file mode 100644
index def6d47..0000000
--- a/arch/tile/include/asm/sockios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sockios.h>
diff --git a/arch/tile/include/asm/statfs.h b/arch/tile/include/asm/statfs.h
deleted file mode 100644
index 0b91fe1..0000000
--- a/arch/tile/include/asm/statfs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/statfs.h>
diff --git a/arch/tile/include/asm/termbits.h b/arch/tile/include/asm/termbits.h
deleted file mode 100644
index 3935b10..0000000
--- a/arch/tile/include/asm/termbits.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termbits.h>
diff --git a/arch/tile/include/asm/termios.h b/arch/tile/include/asm/termios.h
deleted file mode 100644
index 280d78a..0000000
--- a/arch/tile/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termios.h>
diff --git a/arch/tile/include/asm/types.h b/arch/tile/include/asm/types.h
deleted file mode 100644
index b9e79bc..0000000
--- a/arch/tile/include/asm/types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/types.h>
diff --git a/arch/tile/include/asm/ucontext.h b/arch/tile/include/asm/ucontext.h
deleted file mode 100644
index 9bc07b9..0000000
--- a/arch/tile/include/asm/ucontext.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ucontext.h>
diff --git a/arch/tile/include/asm/xor.h b/arch/tile/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/tile/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
-- 
1.6.5.2

