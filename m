Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0LIJag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:30:36 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53609 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0LIJad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:30:33 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 001/211] unicore32: new file arch/unicore32/.gitignore
Date: Thu, 9 Dec 2010 17:30:28 +0800
Message-ID: <01cc01cb9783$b7cdaa10$2768fe30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXg4ZPJLIGGJBoRW+QDfnvlpchAw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	.gitignore file for unicore32 architecture

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/.gitignore |   68
+++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
new file mode 100644
index 0000000..285a7e0
--- /dev/null
+++ b/arch/unicore32/.gitignore
@@ -0,0 +1,68 @@
+#
+# Generated include files
+#
+include/asm/atomic.h
+include/asm/bitsperlong.h
+include/asm/bug.h
+include/asm/bugs.h
+include/asm/cputime.h
+include/asm/current.h
+include/asm/device.h
+include/asm/emergency-restart.h
+include/asm/errno.h
+include/asm/fb.h
+include/asm/fcntl.h
+include/asm/hardirq.h
+include/asm/hw_irq.h
+include/asm/ioctl.h
+include/asm/ioctls.h
+include/asm/ipcbuf.h
+include/asm/irq_regs.h
+include/asm/kdebug.h
+include/asm/kmap_types.h
+include/asm/local.h
+include/asm/mman.h
+include/asm/module.h
+include/asm/msgbuf.h
+include/asm/param.h
+include/asm/parport.h
+include/asm/percpu.h
+include/asm/poll.h
+include/asm/posix_types.h
+include/asm/resource.h
+include/asm/scatterlist.h
+include/asm/sections.h
+include/asm/sembuf.h
+include/asm/serial.h
+include/asm/shmbuf.h
+include/asm/shmparam.h
+include/asm/siginfo.h
+include/asm/signal.h
+include/asm/socket.h
+include/asm/sockios.h
+include/asm/statfs.h
+include/asm/termbits.h
+include/asm/termios.h
+include/asm/topology.h
+include/asm/types.h
+include/asm/ucontext.h
+include/asm/unaligned.h
+include/asm/vga.h
+include/asm/xor.h
+#
+# Generated ld script file
+#
+kernel/vmlinux.lds
+#
+# Generated images in boot
+#
+boot/Image
+boot/zImage
+boot/uImage
+#
+# Generated files in boot/compressed
+#
+boot/compressed/piggy.S
+boot/compressed/piggy.gzip
+boot/compressed/vmlinux
+boot/compressed/vmlinux.lds


