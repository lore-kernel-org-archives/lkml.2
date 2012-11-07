Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2KGJyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:54:46 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:53843 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2KGJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:13 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 01/31] ARC: Generic Headers
Date: Wed,  7 Nov 2012 10:47:24 +0100
Message-Id: <1352281674-2186-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/Kbuild        |   57 ++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/asm-offsets.h |    9 ++++++
 2 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/Kbuild
 create mode 100644 arch/arc/include/asm/asm-offsets.h

diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
new file mode 100644
index 0000000..d6c037a
--- /dev/null
+++ b/arch/arc/include/asm/Kbuild
@@ -0,0 +1,57 @@
+include include/asm-generic/Kbuild.asm
+
+# 7-Oct-12: Jeremy Bennett <jeremy.bennett@embecosm.com>. Some of these
+# headers, beyond those specified in the generic set are needed by user code.
+
+header-y += page.h
+header-y += cachectl.h
+
+generic-y += auxvec.h
+generic-y += bugs.h
+generic-y += bitsperlong.h
+generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fcntl.h
+generic-y += fb.h
+generic-y += ftrace.h
+generic-y += hardirq.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kmap_types.h
+generic-y += kvm_para.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += mman.h
+generic-y += msgbuf.h
+generic-y += param.h
+generic-y += parport.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += stat.h
+generic-y += statfs.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += unaligned.h
+generic-y += user.h
+generic-y += vga.h
+generic-y += xor.h
diff --git a/arch/arc/include/asm/asm-offsets.h b/arch/arc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..dad1876
--- /dev/null
+++ b/arch/arc/include/asm/asm-offsets.h
@@ -0,0 +1,9 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <generated/asm-offsets.h>
-- 
1.7.4.1

