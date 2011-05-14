Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab1ENVQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:16:22 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:14453 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab1ENVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:16:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: torvalds@linux-foundation.org
Cc: hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH .39-final] avr32: add some more at91 to cpu.h definition
Date: Sun, 15 May 2011 00:23:32 +0200
Message-Id: <1305411812-25508-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <4DC3EA35.5030709@atmel.com>
References: <4DC3EA35.5030709@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somme common drivers will need those at91 cpu_is_xxx() definitions.
Those definitions are already in Linus' tree so if we want to use them
in common drivers, we will need them in AVR32 cpu.h file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
Linus,

AVR32 and AT91 were waiting for more fixes to add to a pull request for you.
But it seems that we do not have more patches that can go to .39-final.
So, maybe you can take this trivial patch. It shall allow all definitions to be
available for both architectures into the same kernel revision.

Thanks, best regards.

 arch/avr32/mach-at32ap/include/mach/cpu.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
index 9c96a13..8181293 100644
--- a/arch/avr32/mach-at32ap/include/mach/cpu.h
+++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
@@ -31,8 +31,20 @@
 #define cpu_is_at91sam9263()	(0)
 #define cpu_is_at91sam9rl()	(0)
 #define cpu_is_at91cap9()	(0)
+#define cpu_is_at91cap9_revB()	(0)
+#define cpu_is_at91cap9_revC()	(0)
 #define cpu_is_at91sam9g10()	(0)
+#define cpu_is_at91sam9g20()	(0)
 #define cpu_is_at91sam9g45()	(0)
 #define cpu_is_at91sam9g45es()	(0)
+#define cpu_is_at91sam9m10()	(0)
+#define cpu_is_at91sam9g46()	(0)
+#define cpu_is_at91sam9m11()	(0)
+#define cpu_is_at91sam9x5()	(0)
+#define cpu_is_at91sam9g15()	(0)
+#define cpu_is_at91sam9g35()	(0)
+#define cpu_is_at91sam9x35()	(0)
+#define cpu_is_at91sam9g25()	(0)
+#define cpu_is_at91sam9x25()	(0)
 
 #endif /* __ASM_ARCH_CPU_H */
-- 
1.7.3

