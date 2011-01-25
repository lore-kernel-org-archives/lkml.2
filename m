Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1AYIHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:07:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58917 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1AYIHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tD7MUjn/umaj6PfGqK/KW3YxEKwzdYGUp+rCAVt4HdMmUv9gp/77PkzvSNXc8uegXp
         CaTaKKwHPStw8UmefRUgK772frtjeMAixNRmdkeW9QUCwRR8KcSpWSE2ORBTC1BEnkem
         iypnwysTOYKwvYKJ2AMiNiMvfgedOPTo49aMw=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 6/6] Cpu features overrides for msp platforms.
Date: Tue, 25 Jan 2011 13:53:17 +0530
Message-Id: <1295943797-20467-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>


Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 .../asm/pmc-sierra/msp71xx/cpu-feature-overrides.h |   21 ++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h

diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
new file mode 100644
index 0000000..a80801b
--- /dev/null
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
@@ -0,0 +1,21 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2003, 04, 07 Ralf Baechle (ralf@linux-mips.org)
+ */
+#ifndef __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
+#define __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
+
+#define cpu_has_mips16		1
+#define cpu_has_dsp		1
+#define cpu_has_mipsmt		1
+#define cpu_has_fpu		0
+
+#define cpu_has_mips32r1	0
+#define cpu_has_mips32r2	1
+#define cpu_has_mips64r1	0
+#define cpu_has_mips64r2	0
+
+#endif /* __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H */
-- 
1.7.0.4

