Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab2FGOPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:15:43 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3562 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab2FGOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:15:42 -0400
Message-ID: <1339078540.25798.13.camel@x61.thuisdomein>
Subject: [PATCH] ARM: s3c24xx: remove unused header
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 07 Jun 2012 16:15:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 Jun 2012 14:15:40.0782 (UTC) FILETIME=[04BDA0E0:01CD44B8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since (at least) v2.6.12-rc2 there has been a bast-pmu.h header in the
tree. Currently it can be found at
arch/arm/mach-s3c24xx/include/mach/bast-pmu.h.

It seems that during that entire period nothing included that header and
that none of the named constants it provided were ever used. That header
can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep". But it's again hard to imagine how this could
break anything.

 arch/arm/mach-s3c24xx/include/mach/bast-pmu.h |   40 -------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/bast-pmu.h

diff --git a/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h b/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
deleted file mode 100644
index 4c38b39..0000000
--- a/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* arch/arm/mach-s3c2410/include/mach/bast-pmu.h
- *
- * Copyright (c) 2003-2004 Simtec Electronics
- *	Ben Dooks <ben@simtec.co.uk>
- *	Vincent Sanders <vince@simtec.co.uk>
- *
- * Machine BAST - Power Management chip
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_BASTPMU_H
-#define __ASM_ARCH_BASTPMU_H "08_OCT_2004"
-
-#define BASTPMU_REG_IDENT	(0x00)
-#define BASTPMU_REG_VERSION	(0x01)
-#define BASTPMU_REG_DDCCTRL	(0x02)
-#define BASTPMU_REG_POWER	(0x03)
-#define BASTPMU_REG_RESET	(0x04)
-#define BASTPMU_REG_GWO		(0x05)
-#define BASTPMU_REG_WOL		(0x06)
-#define BASTPMU_REG_WOR		(0x07)
-#define BASTPMU_REG_UID		(0x09)
-
-#define BASTPMU_EEPROM		(0xC0)
-
-#define BASTPMU_EEP_UID		(BASTPMU_EEPROM + 0)
-#define BASTPMU_EEP_WOL		(BASTPMU_EEPROM + 8)
-#define BASTPMU_EEP_WOR		(BASTPMU_EEPROM + 9)
-
-#define BASTPMU_IDENT_0		0x53
-#define BASTPMU_IDENT_1		0x42
-#define BASTPMU_IDENT_2		0x50
-#define BASTPMU_IDENT_3		0x4d
-
-#define BASTPMU_RESET_GUARD	(0x55)
-
-#endif /* __ASM_ARCH_BASTPMU_H */
-- 
1.7.7.6

