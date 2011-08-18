Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1HRTNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:13:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48453 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1HRTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:13:50 -0400
Date: Thu, 18 Aug 2011 20:13:50 +0100
To: richard@nod.at
Subject: Subject: [PATCH 89/91] um: generic ftrace.h will do...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu82I-00089B-2e@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/Kbuild   |    1 +
 arch/um/include/asm/ftrace.h |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)
 delete mode 100644 arch/um/include/asm/ftrace.h

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 5962826..451f451 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,2 +1,3 @@
 generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
+generic-y += ftrace.h
diff --git a/arch/um/include/asm/ftrace.h b/arch/um/include/asm/ftrace.h
deleted file mode 100644
index 40a8c17..0000000
--- a/arch/um/include/asm/ftrace.h
+++ /dev/null
@@ -1 +0,0 @@
-/* empty */
-- 
1.7.2.5


