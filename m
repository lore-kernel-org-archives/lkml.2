Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2FZVMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:12:51 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3738 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab2FZVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:12:50 -0400
Message-ID: <1340745167.1911.13.camel@x61.thuisdomein>
Subject: [PATCH 1/2] ARM: omap: fix typos related to OMAP330
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 23:12:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Jun 2012 21:12:48.0712 (UTC) FILETIME=[7065EC80:01CD53E0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I tracked this set of typos back to commit
9ad5897c2659b3c610e0c717e8b3dbfb496d2c74 ("[ARM] 3143/1: OMAP 4/5:
Update omap include files"). It is just something I noticed while
working on the next patch.

 arch/arm/plat-omap/include/plat/cpu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index 297245d..f2bdf15 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -238,7 +238,7 @@ IS_AM_SUBCLASS(335x, 0x335)
 /*
  * Macros to detect individual cpu types.
  * These are only rarely needed.
- * cpu_is_omap330():	True for OMAP330
+ * cpu_is_omap310():	True for OMAP310
  * cpu_is_omap730():	True for OMAP730
  * cpu_is_omap850():	True for OMAP850
  * cpu_is_omap1510():	True for OMAP1510
@@ -304,7 +304,7 @@ IS_OMAP_TYPE(3517, 0x3517)
 
 /*
  * Whether we have MULTI_OMAP1 or not, we still need to distinguish
- * between 730 vs 850, 330 vs. 1510 and 1611B/5912 vs. 1710.
+ * between 730 vs 850, 310 vs. 1510 and 1611B/5912 vs. 1710.
  */
 
 #if defined(CONFIG_ARCH_OMAP730)
-- 
1.7.7.6

