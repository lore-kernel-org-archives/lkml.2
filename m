Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0IVB3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:29:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42913 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab0IVB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LMNkLKOuboOFk7EffP8AbfZhpL50uWZDtfvQW5/0nweCWl4qpllgI9OcXQnoWnARs2
         fRn1NPy11aTwZ4H1a06pJUtp0XuoRHEMKLv/W8lHlWGRD9xkHXqnx+e0iRg1kj+19dvp
         lHliq1u1ZdlWLT2SA+llingo+QgG/qoA2qXcI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-laptop@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/2 v3]Update broken web addresses archive dot org only.
Date: Tue, 21 Sep 2010 18:29:17 -0700
Message-Id: <1285118957-24965-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1285118957-24965-1-git-send-email-justinmattock@gmail.com>
References: <1285118957-24965-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch consisting of only the broken web addresses using webarchive.org. 
Please have a look and let me know if you want to go on with using these and/or just 
leave the old links in there.
Note: the address needs to have an %2A added to it due to webarchive.org
using a "*" for it's searching capabilities.
Please dont apply this to anything, just comments and changes for now, then
at the right time I'll bunch everything into one patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>

---
 arch/arm/mach-footbridge/Kconfig          |    2 +-
 arch/arm/mach-omap1/Kconfig               |    4 ++--
 arch/arm/mach-pxa/idp.c                   |    4 ++--
 arch/arm/mach-pxa/include/mach/idp.h      |    4 ++--
 arch/arm/mach-sa1100/Kconfig              |    2 +-
 arch/h8300/Kconfig.cpu                    |    2 +-
 arch/h8300/README                         |    3 ++-
 arch/ia64/include/asm/machvec_sn2.h       |    2 +-
 arch/ia64/include/asm/numa.h              |    2 +-
 arch/ia64/kernel/acpi.c                   |    2 +-
 arch/ia64/lib/idiv32.S                    |    2 +-
 arch/ia64/lib/idiv64.S                    |    2 +-
 arch/ia64/sn/kernel/setup.c               |    2 +-
 arch/ia64/sn/kernel/sn2/timer_interrupt.c |    2 +-
 arch/m68k/Kconfig                         |    2 +-
 arch/m68k/mac/via.c                       |    5 ++---
 arch/m68k/q40/README                      |    4 ++--
 arch/sh/cchips/Kconfig                    |    2 +-
 arch/um/os-Linux/start_up.c               |    2 +-
 arch/x86/kernel/cpu/amd.c                 |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/x86/math-emu/README                  |    2 +-
 22 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index bdd2579..fa30857 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -29,7 +29,7 @@ config ARCH_PERSONAL_SERVER
 	  There are no product plans beyond the current research
 	  prototypes at this time.  Information is available at:
 
-	  <http://www.crl.hpl.hp.com/projects/personalserver/>
+	  <http://web.archive.org/web/%2A/http://www.crl.hpl.hp.com/projects/personalserver/>
 
 	  If you have any questions or comments about the  Compaq Personal
 	  Server, send e-mail to <skiff@crl.dec.com>.
diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 5f64963..e3cf9f4 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -118,8 +118,8 @@ config MACH_OMAP_PALMZ71
 	depends on ARCH_OMAP1 && ARCH_OMAP15XX
 	help
 	 Support for the Palm Zire71 PDA. To boot the kernel,
-	 you'll need a PalmOS compatible bootloader; check out
-	 http://hackndev.com/palm/z71 for more information.
+	 you'll need a PalmOS compatible bootloader; For information
+	 http://web.archive.org/web/%2A/http://old.hackndev.com/palm/z71 
 	 Say Y here if you have such a PDA, say N otherwise.
 
 config MACH_OMAP_PALMTT
diff --git a/arch/arm/mach-pxa/idp.c b/arch/arm/mach-pxa/idp.c
index bc78c4d..b521a64 100644
--- a/arch/arm/mach-pxa/idp.c
+++ b/arch/arm/mach-pxa/idp.c
@@ -11,8 +11,8 @@
  *              Initial code
  *
  *  2005-02-15: Cliff Brake <cliff.brake@gmail.com>
- *  		<http://www.vibren.com> <http://bec-systems.com>
- *              Updated for 2.6 kernel
+ *  		<http://web.archive.org/web/%2A/http://www.vibren.com> 
+ *             <http://bec-systems.com> Updated for 2.6 kernel
  *
  */
 
diff --git a/arch/arm/mach-pxa/include/mach/idp.h b/arch/arm/mach-pxa/include/mach/idp.h
index 5eff96f..d1a3d5d 100644
--- a/arch/arm/mach-pxa/include/mach/idp.h
+++ b/arch/arm/mach-pxa/include/mach/idp.h
@@ -11,8 +11,8 @@
  *             Initial code
  *
  * 2005-02-15: Cliff Brake <cliff.brake@gmail.com>
- *             <http://www.vibren.com> <http://bec-systems.com>
- *             Changes for 2.6 kernel.
+ *             <http://web.archive.org/web/%2A/http://www.vibren.com> 
+ *             <http://bec-systems.com> Changes for 2.6 kernel.
  */
 
 
diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index 5da8c35..11bc60f 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -108,7 +108,7 @@ config SA1100_HACKKIT
 	select CPU_FREQ_SA1100
 	help
 	  Say Y here to support the HackKit Core CPU Board
-	  <http://hackkit.eletztrick.de>;
+	  <http://web.archive.org/web/%2A/http://hackkit.eletztrick.de>;
 
 config SA1100_LART
 	bool "LART"
diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index 8de966a..49d55ba 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -20,7 +20,7 @@ config H8300H_AKI3068NET
 	  <http://akizukidenshi.com/catalog/default.aspx>
 	  AE-3068/69 Evaluation Board Support
 	  More Information.
-	  <http://www.microtronique.com/ae3069lan.htm>
+	  <http://web.archive.org/web/20021204203007/http://www.microtronique.com/ae3069lan.htm>
 
 config H8300H_H8MAX
 	bool "H8MAX"
diff --git a/arch/h8300/README b/arch/h8300/README
index 7dac451..fa9af54 100644
--- a/arch/h8300/README
+++ b/arch/h8300/README
@@ -11,7 +11,8 @@ H8/300H and H8S
 2.AE 3068/AE 3069
   more information 
   MICROTRONIQUE <http://www.microtronique.com/>
-  Akizuki Denshi Tsusho Ltd. <http://www.akizuki.ne.jp> (Japanese Only)
+  Akizuki Denshi Tsusho Ltd. (Japanese Only)
+  <http://web.archive.org/web/%2A/http://www.akizuki.ne.jp>
 
 3.H8MAX 
   see http://strawberry-linux.com/h8/h8max.html (Japanese Only)
diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
index f061a30..bccea57 100644
--- a/arch/ia64/include/asm/machvec_sn2.h
+++ b/arch/ia64/include/asm/machvec_sn2.h
@@ -22,7 +22,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://web.archive.org/web/20040311225417/oss.sgi.com/projects/GenInfo/NoticeExplan/ 
  */
 
 #ifndef _ASM_IA64_MACHVEC_SN2_H
diff --git a/arch/ia64/include/asm/numa.h b/arch/ia64/include/asm/numa.h
index 6a8a27c..82b664d 100644
--- a/arch/ia64/include/asm/numa.h
+++ b/arch/ia64/include/asm/numa.h
@@ -52,7 +52,7 @@ extern struct node_cpuid_s node_cpuid[NR_CPUS];
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/%2A/http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf 
  *
  * This is a matrix with "distances" between nodes, they should be
  * proportional to the memory access latency ratios.
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c6c90f3..4538449 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -452,7 +452,7 @@ static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/%2A/http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf 
  */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
diff --git a/arch/ia64/lib/idiv32.S b/arch/ia64/lib/idiv32.S
index 2ac28bf..f4938e1 100644
--- a/arch/ia64/lib/idiv32.S
+++ b/arch/ia64/lib/idiv32.S
@@ -7,7 +7,7 @@
  * This code is based on the application note entitled "Divide, Square Root
  * and Remainder Algorithms for the IA-64 Architecture".  This document
  * is available as Intel document number 248725-002 or via the web at
- * http://developer.intel.com/software/opensource/numerics/
+ * http://web.archive.org/web/20020611073250/developer.intel.com/software/products/opensource/libraries/num.htm 
  *
  * For more details on the theory behind these algorithms, see "IA-64
  * and Elementary Functions" by Peter Markstein; HP Professional Books
diff --git a/arch/ia64/lib/idiv64.S b/arch/ia64/lib/idiv64.S
index f69bd2b..5c3fb6d 100644
--- a/arch/ia64/lib/idiv64.S
+++ b/arch/ia64/lib/idiv64.S
@@ -7,7 +7,7 @@
  * This code is based on the application note entitled "Divide, Square Root
  * and Remainder Algorithms for the IA-64 Architecture".  This document
  * is available as Intel document number 248725-002 or via the web at
- * http://developer.intel.com/software/opensource/numerics/
+ * http://web.archive.org/web/20020611073250/developer.intel.com/software/products/opensource/libraries/num.htm 
  *
  * For more details on the theory behind these algorithms, see "IA-64
  * and Elementary Functions" by Peter Markstein; HP Professional Books
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..0d0c0d2 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -234,7 +234,7 @@ static void __cpuinit sn_check_for_wars(void)
  * Since pcdp support in SN is not supported in the 2.4 kernel (or at least
  * the one lbs is based on) just declare the needed structs here.
  *
- * Reference spec http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
+ * Reference spec http://web.archive.org/web/%2A/http://www.dig64.org/specifications/DIG64_PCDPv20.pdf 
  *
  * Returns 0 if no acceptable vga is found, !0 otherwise.
  *
diff --git a/arch/ia64/sn/kernel/sn2/timer_interrupt.c b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
index 103d6ea..a058d88 100644
--- a/arch/ia64/sn/kernel/sn2/timer_interrupt.c
+++ b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
@@ -24,7 +24,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://web.archive.org/web/20040311225417/oss.sgi.com/projects/GenInfo/NoticeExplan/ 
  */
 
 #include <linux/interrupt.h>
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..6c0ddd2 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -221,7 +221,7 @@ config SUN3X
 	  Be warned that this support is very experimental.
 	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
 	  General Linux information on the Sun 3x series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+	  is at <http://web.archive.org/web/%2A/angelfire.com/ca2/tech68k/sun3.html>.
 
 	  If you don't want to compile a kernel for a Sun 3x, say N.
 
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index e71166d..26105ba 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -6,10 +6,9 @@
  *
  * CSA: Motorola seems to have removed documentation on the 6522 from
  * their web site; try
- *     http://nerini.drf.com/vectrex/other/text/chips/6522/
- *     http://www.zymurgy.net/classic/vic20/vicdet1.htm
+ *     http://web.archive.org/web/%2A/http://www.zymurgy.net/classic/vic20/vicdet1.htm 
  * and
- *     http://193.23.168.87/mikro_laborversuche/via_iobaustein/via6522_1.html
+ *    http://web.archive.org/web/%2A/http://193.23.168.87/mikro_laborversuche/via_iobaustein/via6522_1.html 
  * for info.  A full-text web search on 6522 AND VIA will probably also
  * net some usefulness. <cananian@alumni.princeton.edu> 20apr1999
  *
diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
index 92806c0..0f71431 100644
--- a/arch/m68k/q40/README
+++ b/arch/m68k/q40/README
@@ -1,8 +1,8 @@
 Linux for the Q40
 =================
 
-You may try http://www.geocities.com/SiliconValley/Bay/2602/ for
-some up to date information. Booter and other tools will be also
+You may try http://web.archive.org/web/%2A/http://geocities.com/SiliconValley/Bay/2602/ 
+for some up to date information. Booter and other tools will be also
 available from this place or http://www.linux-m68k.org/mail.html 
 and mirrors.
 
diff --git a/arch/sh/cchips/Kconfig b/arch/sh/cchips/Kconfig
index a5ab2ec..65edb36 100644
--- a/arch/sh/cchips/Kconfig
+++ b/arch/sh/cchips/Kconfig
@@ -17,7 +17,7 @@ config HD64461
 	  PCMCIA controller supporting 2 slots.
 
 	  More information is available at
-	  <http://semiconductor.hitachi.com/windowsce/superh/sld013.htm>.
+	  <http://web.archive.org/web/%2A/http://semiconductor.hitachi.com/windowsce/superh/sld013.htm>.
 
 	  Say Y if you want support for the HD64461.
 	  Otherwise, say N.
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 02ee9ad..6704172 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -195,7 +195,7 @@ __uml_setup("nosysemu", nosysemu_cmd_param,
 "    SYSEMU is a performance-patch introduced by Laurent Vivier. It changes\n"
 "    behaviour of ptrace() and helps reducing host context switch rate.\n"
 "    To make it working, you need a kernel patch for your host, too.\n"
-"    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
+"    See http://web.archive.org/web/%2A/http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
 "    information.\n\n");
 
 static void __init check_sysemu(void)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..fac4c61 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -23,7 +23,7 @@
  *	contact AMD for precise details and a CPU swap.
  *
  *	See	http://www.multimania.com/poulot/k6bug.html
- *		http://www.amd.com/K6/k6docs/revgd.html
+ *		http://web.archive.org/web/%2A/http://www.amd.com/K6/k6docs/revgd.html	
  *
  *	The following test is erm.. interesting. AMD neglected to up
  *	the chip setting when fixing the bug but they also tweaked some
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..0ed309d 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -21,7 +21,7 @@
  *  Opteron Processors" available for download from www.amd.com
  *
  *  Tables for specific CPUs can be inferred from
- *     http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf
+ *    http://web.archive.org/web/%2A/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf 
  */
 
 #include <linux/kernel.h>
diff --git a/arch/x86/math-emu/README b/arch/x86/math-emu/README
index e623549..18fbaa9 100644
--- a/arch/x86/math-emu/README
+++ b/arch/x86/math-emu/README
@@ -46,7 +46,7 @@ Please report bugs, etc to me at:
 or     b.metzenthen@medoto.unimelb.edu.au
 
 For more information on the emulator and on floating point topics, see
-my web pages, currently at  http://www.suburbia.net/~billm/
+my web pages, currently at http://web.archive.org/web/20011207081554/suburbia.net/~billm/floating-point/index.html 
 
 
 --Bill Metzenthen
-- 
1.7.2.1

