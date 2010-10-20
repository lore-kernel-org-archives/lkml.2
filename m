Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0JTV6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:58:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51764 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0JTV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wbJVuwlkD4wSn7viE1H3doJ25miH+qkipL2LJzl4P4FtwkVHlabF43dTfexDErzdGV
         lAa+I8fGqM8CNrbZQPIXWI8N+J0YUPOrw5FSaYd7MbDCof5gFL/W8Wx1AFUEUJZXb2Aj
         vTdB1WpKmITcnA0f5qEQ1y51iaWZnkzcbtXyc=
Message-ID: <4CBF6602.3070801@gmail.com>
Date: Wed, 20 Oct 2010 23:58:26 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Removal of duplicate includes from many files
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>	<4CA4D61C.2010909@gmail.com>	<4CA4E76E.1050602@gmail.com>	<20101004161600.8cdf4e0c.akpm@linux-foundation.org> <AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
In-Reply-To: <AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

W dniu 2010-10-05 01:33, Zimny Lech pisze:
> 2010/10/5 Andrew Morton<akpm@linux-foundation.org>:
>> Removal of duplicated includes is a somewhat dangerous thing.  If
>> someone else says "hey, there's a duplicated include" and then fixes
>> it, and if this patch removes the other include then whoops, we broke
>> the build.  This has happened before.
> Yeah, right.
>
>> So I'd ask that you redo and resend this patch shortly after 2.6.36 is
>> released please, so I can get it into mainline quickly thus minimising
>> the opportunity for such breakage.
>

I rebased series against 2.6.36 and I checked if something has not been 
removed by someone else. Please pull
git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodi1

or apply attached patch

Kind regards,
ZL


Removal of duplicate includes from arch/arm/mach-davinci/board-da850-evm.c
Removal of duplicate includes from 
arch/arm/plat-nomadik/include/plat/ste_dma40.h
Removal of duplicate includes from arch/arm/mach-shmobile/board-ap4evb.c
Removal of duplicate includes from arch/arm/mach-tegra/timer.c
Removal of duplicate includes from arch/x86/mm/init_64.c
Removal of duplicate includes from arch/x86/xen/enlighten.c
Removal of duplicate includes from arch/tile/kernel/setup.c
Removal of duplicate includes from drivers/ide/ide-tape.c
Removal of duplicate includes from drivers/media/IR/lirc_dev.c
Removal of duplicate includes from drivers/net/wireless/libertas/cfg.c
Removal of duplicate includes from drivers/net/pxa168_eth.c
Removal of duplicate includes from drivers/platform/x86/intel_pmic_gpio.c
Removal of duplicate includes from drivers/staging/lirc/lirc_parallel.c
Removal of duplicate includes from drivers/staging/spectra/lld_mtd.c
Removal of duplicate includes from drivers/staging/tidspbridge/gen/gb.c
Removal of duplicate includes from drivers/staging/tidspbridge/gen/gs.c
Removal of duplicate includes from drivers/video/omap/lcd_omap3beagle.c
Removal of duplicate includes from include/linux/virtio_9p.h
Removal of duplicate includes from kernel/trace/trace_kprobe.c
Removal of duplicate includes from net/netfilter/xt_ipvs.c
Removal of duplicate includes from net/caif/caif_socket.c
Removal of duplicate includes from sound/soc/nuc900/nuc900-ac97.c

Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>

diff --git a/arch/arm/mach-davinci/board-da850-evm.c 
b/arch/arm/mach-davinci/board-da850-evm.c
index fdc2cc5..851cc45 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -26,7 +26,6 @@
  #include <linux/mtd/physmap.h>
  #include <linux/regulator/machine.h>
  #include <linux/regulator/tps6507x.h>
-#include <linux/mfd/tps6507x.h>
  #include <linux/input/tps6507x-ts.h>

  #include <asm/mach-types.h>
diff --git a/arch/arm/mach-shmobile/board-ap4evb.c 
b/arch/arm/mach-shmobile/board-ap4evb.c
index 95935c8..3ebb5be 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -30,7 +30,6 @@
  #include <linux/mtd/mtd.h>
  #include <linux/mtd/partitions.h>
  #include <linux/mtd/physmap.h>
-#include <linux/mmc/host.h>
  #include <linux/mmc/sh_mmcif.h>
  #include <linux/i2c.h>
  #include <linux/i2c/tsc2007.h>
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index 2f42021..9057d6f 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -28,7 +28,6 @@
  #include <linux/cnt32_to_63.h>

  #include <asm/mach/time.h>
-#include <asm/mach/time.h>
  #include <asm/localtimer.h>

  #include <mach/iomap.h>
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h 
b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 5fbde4b..93a8126 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -14,7 +14,6 @@
  #include <linux/dmaengine.h>
  #include <linux/workqueue.h>
  #include <linux/interrupt.h>
-#include <linux/dmaengine.h>

  /* dev types for memcpy */
  #define STEDMA40_DEV_DST_MEMORY (-1)
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index e7d54c7..45874f7 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -30,8 +30,6 @@
  #include <linux/timex.h>
  #include <asm/setup.h>
  #include <asm/sections.h>
-#include <asm/sections.h>
-#include <asm/cacheflush.h>
  #include <asm/cacheflush.h>
  #include <asm/pgalloc.h>
  #include <asm/mmu_context.h>
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..612f353 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -50,7 +50,6 @@
  #include <asm/numa.h>
  #include <asm/cacheflush.h>
  #include <asm/init.h>
-#include <linux/bootmem.h>

  static unsigned long dma_reserve __initdata;

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7d46c84..3396891 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -58,7 +58,6 @@
  #include <asm/pgtable.h>
  #include <asm/tlbflush.h>
  #include <asm/reboot.h>
-#include <asm/setup.h>
  #include <asm/stackprotector.h>
  #include <asm/hypervisor.h>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6d622cb..cd3539e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -36,7 +36,6 @@
  #include <linux/slab.h>
  #include <linux/pci.h>
  #include <linux/ide.h>
-#include <linux/smp_lock.h>
  #include <linux/completion.h>
  #include <linux/bitops.h>
  #include <linux/mutex.h>
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 899891b..42b5e64 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -27,7 +27,6 @@
  #include <linux/fs.h>
  #include <linux/poll.h>
  #include <linux/completion.h>
-#include <linux/errno.h>
  #include <linux/mutex.h>
  #include <linux/wait.h>
  #include <linux/unistd.h>
diff --git a/drivers/net/pxa168_eth.c b/drivers/net/pxa168_eth.c
index 85eddda..720da24 100644
--- a/drivers/net/pxa168_eth.c
+++ b/drivers/net/pxa168_eth.c
@@ -42,8 +42,6 @@
  #include <linux/types.h>
  #include <asm/pgtable.h>
  #include <asm/system.h>
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
  #include <asm/cacheflush.h>
  #include <linux/pxa168_eth.h>

diff --git a/drivers/net/wireless/libertas/cfg.c 
b/drivers/net/wireless/libertas/cfg.c
index 3e82f16..2372abb 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -9,7 +9,6 @@
  #include <linux/sched.h>
  #include <linux/wait.h>
  #include <linux/slab.h>
-#include <linux/sched.h>
  #include <linux/ieee80211.h>
  #include <net/cfg80211.h>
  #include <asm/unaligned.h>
diff --git a/drivers/platform/x86/intel_pmic_gpio.c 
b/drivers/platform/x86/intel_pmic_gpio.c
index 5cdcff6..73eae6f 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -29,7 +29,6 @@
  #include <linux/init.h>
  #include <linux/io.h>
  #include <linux/gpio.h>
-#include <linux/interrupt.h>
  #include <asm/intel_scu_ipc.h>
  #include <linux/device.h>
  #include <linux/intel_pmic_gpio.h>
diff --git a/drivers/staging/lirc/lirc_parallel.c 
b/drivers/staging/lirc/lirc_parallel.c
index 6da4a8c..0c831f5 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -40,7 +40,6 @@
  #include <linux/delay.h>

  #include <linux/io.h>
-#include <linux/signal.h>
  #include <linux/irq.h>
  #include <linux/uaccess.h>
  #include <asm/div64.h>
diff --git a/drivers/staging/spectra/lld_mtd.c 
b/drivers/staging/spectra/lld_mtd.c
index 0de05b1..ec57a15 100644
--- a/drivers/staging/spectra/lld_mtd.c
+++ b/drivers/staging/spectra/lld_mtd.c
@@ -24,9 +24,6 @@
  #include "ffsdefs.h"
  #include "lld_emu.h"
  #include "lld.h"
-#if CMD_DMA
-#include "lld_cdma.h"
-#endif

  #define GLOB_LLD_PAGES           64
  #define GLOB_LLD_PAGE_SIZE       (512+16)
diff --git a/drivers/staging/tidspbridge/gen/gb.c 
b/drivers/staging/tidspbridge/gen/gb.c
index 06eb3d3..9f59023 100644
--- a/drivers/staging/tidspbridge/gen/gb.c
+++ b/drivers/staging/tidspbridge/gen/gb.c
@@ -15,7 +15,6 @@
   * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
   * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
   */
-#include <linux/types.h>

  /*  ----------------------------------- DSP/BIOS Bridge */
  #include <linux/types.h>
diff --git a/drivers/staging/tidspbridge/gen/gs.c 
b/drivers/staging/tidspbridge/gen/gs.c
index 9fc6144..8335bf5 100644
--- a/drivers/staging/tidspbridge/gen/gs.c
+++ b/drivers/staging/tidspbridge/gen/gs.c
@@ -19,7 +19,6 @@
  #include <linux/types.h>
  /*  ----------------------------------- DSP/BIOS Bridge */
  #include <dspbridge/dbdefs.h>
-#include <linux/types.h>

  /*  ----------------------------------- This */
  #include <dspbridge/gs.h>
diff --git a/drivers/video/omap/lcd_omap3beagle.c 
b/drivers/video/omap/lcd_omap3beagle.c
index ca75cc2..ac715f9 100644
--- a/drivers/video/omap/lcd_omap3beagle.c
+++ b/drivers/video/omap/lcd_omap3beagle.c
@@ -26,7 +26,6 @@
  #include <linux/i2c/twl.h>

  #include <plat/mux.h>
-#include <plat/mux.h>
  #include <asm/mach-types.h>

  #include "omapfb.h"
diff --git a/include/linux/virtio_9p.h b/include/linux/virtio_9p.h
index 1faa80d..e68b439 100644
--- a/include/linux/virtio_9p.h
+++ b/include/linux/virtio_9p.h
@@ -5,7 +5,6 @@
  #include <linux/types.h>
  #include <linux/virtio_ids.h>
  #include <linux/virtio_config.h>
-#include <linux/types.h>

  /* The feature bitmap for virtio 9P */

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 544301d..87f0a95 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -31,7 +31,6 @@
  #include <linux/perf_event.h>
  #include <linux/stringify.h>
  #include <linux/limits.h>
-#include <linux/uaccess.h>
  #include <asm/bitsperlong.h>

  #include "trace.h"
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 4bf28f2..4c49c71 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -15,7 +15,6 @@
  #include <linux/poll.h>
  #include <linux/tcp.h>
  #include <linux/uaccess.h>
-#include <linux/mutex.h>
  #include <linux/debugfs.h>
  #include <linux/caif/caif_socket.h>
  #include <asm/atomic.h>
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 7a4d66d..9127a3d 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -16,7 +16,6 @@
  #include <linux/ip_vs.h>
  #include <linux/types.h>
  #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/x_tables.h>
  #include <linux/netfilter/xt_ipvs.h>
  #include <net/netfilter/nf_conntrack.h>

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index caa7c90..265a950 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -20,7 +20,6 @@
  #include <sound/pcm.h>
  #include <sound/initval.h>
  #include <sound/soc.h>
-#include <linux/device.h>
  #include <linux/clk.h>

  #include <mach/mfp.h>

