Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1HRTNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:13:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1HRTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:13:20 -0400
Date: Thu, 18 Aug 2011 20:13:20 +0100
To: richard@nod.at
Subject: Subject: [PATCH 86/91] um: hw_irq.h can go generic as well
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu81o-00088K-1x@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/Kbuild   |    2 +-
 arch/um/include/asm/hw_irq.h |    7 -------
 2 files changed, 1 insertions(+), 8 deletions(-)
 delete mode 100644 arch/um/include/asm/hw_irq.h

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index e16895d..5962826 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,2 +1,2 @@
 generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
-generic-y += irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
+generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
diff --git a/arch/um/include/asm/hw_irq.h b/arch/um/include/asm/hw_irq.h
deleted file mode 100644
index 1cf84cf..0000000
--- a/arch/um/include/asm/hw_irq.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_UM_HW_IRQ_H
-#define _ASM_UM_HW_IRQ_H
-
-#include "asm/irq.h"
-#include "asm/archparam.h"
-
-#endif
-- 
1.7.2.5


