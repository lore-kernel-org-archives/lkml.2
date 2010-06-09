Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0FILVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:21:33 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37187 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235Ab0FILVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:21:31 -0400
Date: Wed, 9 Jun 2010 13:21:30 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ralf Baechle <ralf@linux-mips.org>, Manuel Lauss <manuel.lauss@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 4/9] Removing dead CONFIG_MTD_PB1550_BOOT,
 CONFIG_MTD_PB1550_USER
Message-ID: <038d00ad3c402eb0a941b034daecdc3603d82e37.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MTD_PB1550_BOOT, CONFIG_MTD_PB1550_USER doesn't exist in
Kconfig, therefore removing all references for it from the source
code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/mips/include/asm/mach-pb1x00/pb1550.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/mach-pb1x00/pb1550.h b/arch/mips/include/asm/mach-pb1x00/pb1550.h
index 5879641..fc4d766 100644
--- a/arch/mips/include/asm/mach-pb1x00/pb1550.h
+++ b/arch/mips/include/asm/mach-pb1x00/pb1550.h
@@ -40,14 +40,6 @@
 #define SMBUS_PSC_BASE		PSC2_BASE_ADDR
 #define I2S_PSC_BASE		PSC3_BASE_ADDR
 
-#if defined(CONFIG_MTD_PB1550_BOOT) && defined(CONFIG_MTD_PB1550_USER)
-#define PB1550_BOTH_BANKS
-#elif defined(CONFIG_MTD_PB1550_BOOT) && !defined(CONFIG_MTD_PB1550_USER)
-#define PB1550_BOOT_ONLY
-#elif !defined(CONFIG_MTD_PB1550_BOOT) && defined(CONFIG_MTD_PB1550_USER)
-#define PB1550_USER_ONLY
-#endif
-
 /*
  * Timing values as described in databook, * ns value stripped of
  * lower 2 bits.
-- 
1.6.3.3

