Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2LXTTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:19:35 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:41075 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2LXTTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:19:32 -0500
Date: Mon, 24 Dec 2012 13:19:25 -0600
Message-Id: <E1TnDYb-0003FO-4k@localhost>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org, sshtylyov@mvista.com
Subject: [PATCH v2] MIPS: MSP71xx: Move include files
From: Shane McDonald <mcdonald.shane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Yosemite's gone we can move the MSP71xx include files
one level up.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
Patch history:
V1: Original patch
V2: Use format-patch's -M option to indicate file renames

 .../cpu-feature-overrides.h                        |    0
 .../msp71xx => mach-pmcs-msp71xx}/gpio.h           |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_cic_int.h    |    0
 .../msp_gpio_macros.h                              |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_int.h        |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_pci.h        |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_prom.h       |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_regops.h     |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_regs.h       |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_slp_int.h    |    0
 .../msp71xx => mach-pmcs-msp71xx}/msp_usb.h        |    0
 .../msp71xx => mach-pmcs-msp71xx}/war.h            |    0
 arch/mips/pmcs-msp71xx/Platform                    |    2 +-
 13 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/cpu-feature-overrides.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/gpio.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_cic_int.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_gpio_macros.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_int.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_pci.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_prom.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_regops.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_regs.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_slp_int.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/msp_usb.h (100%)
 rename arch/mips/include/asm/{pmc-sierra/msp71xx => mach-pmcs-msp71xx}/war.h (100%)

diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h b/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/war.h b/arch/mips/include/asm/mach-pmcs-msp71xx/war.h
similarity index 100%
rename from arch/mips/include/asm/pmc-sierra/msp71xx/war.h
rename to arch/mips/include/asm/mach-pmcs-msp71xx/war.h
diff --git a/arch/mips/pmcs-msp71xx/Platform b/arch/mips/pmcs-msp71xx/Platform
index 9a86e29..7af0734 100644
--- a/arch/mips/pmcs-msp71xx/Platform
+++ b/arch/mips/pmcs-msp71xx/Platform
@@ -2,6 +2,6 @@
 # PMC-Sierra MSP SOCs
 #
 platform-$(CONFIG_PMC_MSP)	+= pmcs-msp71xx/
-cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/pmc-sierra/msp71xx \
+cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/mach-pmcs-msp71xx \
 					-mno-branch-likely
 load-$(CONFIG_PMC_MSP)		+= 0xffffffff80100000
-- 
1.7.2.5

