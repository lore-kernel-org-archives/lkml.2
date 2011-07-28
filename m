Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1G1P66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab1G1PuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/40] UAPI: Convert #include "..." to #include <path/...> in
 kernel system headers [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:49:41 +0100
Message-ID: <20110728154940.16618.23392.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert #include "..." to #include <path/...> in kernel system headers.

scripts/uapi-disintegrate/system-headers.pl was used

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/include/asm/localtimer.h                |    2 +
 arch/arm/include/asm/page.h                      |    2 +
 arch/arm/include/asm/pgtable.h                   |    2 +
 arch/arm/include/asm/vfpmacros.h                 |    2 +
 arch/cris/include/arch-v10/arch/sv_addr_ag.h     |    2 +
 arch/cris/include/arch-v10/arch/svinto.h         |    2 +
 arch/cris/include/arch-v32/arch/dma.h            |    2 +
 arch/cris/include/arch-v32/arch/hwregs/dma.h     |    2 +
 arch/m68k/include/asm/cacheflush.h               |    4 +-
 arch/m68k/include/asm/entry.h                    |    4 +-
 arch/m68k/include/asm/io.h                       |    4 +-
 arch/m68k/include/asm/m68360.h                   |    8 ++---
 arch/m68k/include/asm/m68360_enet.h              |    2 +
 arch/m68k/include/asm/page.h                     |    4 +-
 arch/m68k/include/asm/pgtable.h                  |    4 +-
 arch/m68k/include/asm/q40_master.h               |    2 +
 arch/m68k/include/asm/uaccess.h                  |    4 +-
 arch/microblaze/include/asm/mmu_context.h        |    2 +
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h  |    2 +
 arch/mips/include/asm/mach-pnx833x/gpio.h        |    2 +
 arch/mips/include/asm/octeon/cvmx-asm.h          |    2 +
 arch/mips/include/asm/octeon/cvmx-spinlock.h     |    2 +
 arch/mips/include/asm/octeon/cvmx.h              |   36 +++++++++++-----------
 arch/mips/include/asm/octeon/octeon-model.h      |    2 +
 arch/mips/include/asm/octeon/octeon.h            |    2 +
 arch/mips/include/asm/sibyte/bcm1480_int.h       |    2 +
 arch/mips/include/asm/sibyte/bcm1480_l2c.h       |    2 +
 arch/mips/include/asm/sibyte/bcm1480_mc.h        |    2 +
 arch/mips/include/asm/sibyte/bcm1480_regs.h      |    4 +-
 arch/mips/include/asm/sibyte/bcm1480_scd.h       |    4 +-
 arch/mips/include/asm/sibyte/sb1250_dma.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_genbus.h     |    2 +
 arch/mips/include/asm/sibyte/sb1250_int.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_l2c.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_ldt.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_mac.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_mc.h         |    2 +
 arch/mips/include/asm/sibyte/sb1250_regs.h       |    2 +
 arch/mips/include/asm/sibyte/sb1250_scd.h        |    2 +
 arch/mips/include/asm/sibyte/sb1250_smbus.h      |    2 +
 arch/mips/include/asm/sibyte/sb1250_syncser.h    |    2 +
 arch/mips/include/asm/sibyte/sb1250_uart.h       |    2 +
 arch/powerpc/include/asm/ps3.h                   |    2 +
 arch/powerpc/include/asm/ucc_fast.h              |    2 +
 arch/powerpc/include/asm/ucc_slow.h              |    2 +
 arch/sh/include/asm/checksum.h                   |    2 +
 arch/sh/include/asm/mmu_context.h                |    4 +-
 arch/sh/include/asm/posix_types.h                |    8 ++---
 arch/sh/include/asm/processor.h                  |    4 +-
 arch/sh/include/asm/ptrace.h                     |    4 +-
 arch/sh/include/asm/string.h                     |    4 +-
 arch/sh/include/asm/syscall.h                    |    4 +-
 arch/sh/include/asm/syscalls.h                   |    4 +-
 arch/sh/include/asm/system.h                     |    4 +-
 arch/sh/include/asm/tlb.h                        |    2 +
 arch/sh/include/asm/uaccess.h                    |    4 +-
 arch/sh/include/asm/unistd.h                     |    8 ++---
 arch/sh/include/mach-ecovec24/mach/romimage.h    |    2 +
 arch/sh/include/mach-kfr2r09/mach/romimage.h     |    2 +
 arch/unicore32/include/mach/PKUnity.h            |   36 +++++++++++-----------
 arch/unicore32/include/mach/hardware.h           |    2 +
 arch/unicore32/include/mach/uncompress.h         |    4 +-
 arch/x86/include/asm/atomic.h                    |    4 +-
 arch/x86/include/asm/calling.h                   |    2 +
 arch/x86/include/asm/checksum.h                  |    4 +-
 arch/x86/include/asm/cmpxchg.h                   |    4 +-
 arch/x86/include/asm/mmzone.h                    |    4 +-
 arch/x86/include/asm/mutex.h                     |    4 +-
 arch/x86/include/asm/numa.h                      |    4 +-
 arch/x86/include/asm/pci.h                       |    2 +
 arch/x86/include/asm/pgtable.h                   |    4 +-
 arch/x86/include/asm/pgtable_types.h             |    4 +-
 arch/x86/include/asm/posix_types.h               |    8 ++---
 arch/x86/include/asm/seccomp.h                   |    4 +-
 arch/x86/include/asm/string.h                    |    4 +-
 arch/x86/include/asm/suspend.h                   |    4 +-
 arch/x86/include/asm/uaccess.h                   |    4 +-
 arch/x86/include/asm/unistd.h                    |    8 ++---
 arch/x86/include/asm/user.h                      |    4 +-
 arch/x86/include/asm/xen/interface.h             |    4 +-
 arch/x86/include/asm/xor.h                       |    4 +-
 include/acpi/acpi.h                              |   18 ++++++-----
 include/acpi/acpiosxf.h                          |    4 +-
 include/acpi/acpixf.h                            |    4 +-
 include/acpi/platform/acenv.h                    |    2 +
 include/acpi/platform/aclinux.h                  |    2 +
 include/drm/drm.h                                |    2 +
 include/drm/drmP.h                               |   16 +++++-----
 include/drm/drm_buffer.h                         |    2 +
 include/drm/drm_encoder_slave.h                  |    4 +-
 include/drm/drm_memory.h                         |    2 +
 include/drm/drm_sarea.h                          |    2 +
 include/drm/drm_sman.h                           |    4 +-
 include/drm/i915_drm.h                           |    2 +
 include/drm/mga_drm.h                            |    2 +
 include/drm/radeon_drm.h                         |    2 +
 include/drm/ttm/ttm_bo_api.h                     |    2 +
 include/drm/ttm/ttm_bo_driver.h                  |   16 +++++-----
 include/drm/ttm/ttm_execbuf_util.h               |    2 +
 include/drm/ttm/ttm_lock.h                       |    2 +
 include/drm/ttm/ttm_object.h                     |    2 +
 include/drm/ttm/ttm_page_alloc.h                 |    4 +-
 include/drm/via_drm.h                            |    2 +
 include/linux/bcma/bcma.h                        |    2 +
 include/linux/ceph/ceph_fs.h                     |    4 +-
 include/linux/ceph/debugfs.h                     |    4 +-
 include/linux/ceph/decode.h                      |    2 +
 include/linux/ceph/libceph.h                     |   14 ++++-----
 include/linux/ceph/mdsmap.h                      |    2 +
 include/linux/ceph/messenger.h                   |    4 +-
 include/linux/ceph/mon_client.h                  |    2 +
 include/linux/ceph/msgpool.h                     |    2 +
 include/linux/ceph/osd_client.h                  |    6 ++--
 include/linux/ceph/osdmap.h                      |    4 +-
 include/linux/ceph/rados.h                       |    2 +
 include/linux/ceph/types.h                       |    6 ++--
 include/linux/crush/mapper.h                     |    2 +
 include/linux/drbd_tag_magic.h                   |   10 +++---
 include/linux/netfilter/nf_conntrack_h323_asn1.h |    2 +
 include/scsi/osd_attributes.h                    |    2 +
 include/scsi/osd_initiator.h                     |    4 +-
 include/scsi/osd_sec.h                           |    4 +-
 include/sound/ac97_codec.h                       |    6 ++--
 include/sound/ad1816a.h                          |    6 ++--
 include/sound/ak4531_codec.h                     |    4 +-
 include/sound/cs46xx.h                           |   10 +++---
 include/sound/cs46xx_dsp_spos.h                  |    4 +-
 include/sound/cs46xx_dsp_task_types.h            |    2 +
 include/sound/emu10k1_synth.h                    |    4 +-
 include/sound/emu8000.h                          |    4 +-
 include/sound/emux_legacy.h                      |    2 +
 include/sound/emux_synth.h                       |   14 ++++-----
 include/sound/es1688.h                           |    4 +-
 include/sound/gus.h                              |   10 +++---
 include/sound/mpu401.h                           |    2 +
 include/sound/pcm.h                              |    2 +
 include/sound/rawmidi.h                          |    2 +
 include/sound/sb.h                               |    4 +-
 include/sound/sb16_csp.h                         |    4 +-
 include/sound/seq_kernel.h                       |    2 +
 include/sound/seq_midi_emul.h                    |    2 +
 include/sound/seq_midi_event.h                   |    2 +
 include/sound/seq_oss.h                          |    4 +-
 include/sound/seq_virmidi.h                      |    4 +-
 include/sound/snd_wavefront.h                    |    8 ++---
 include/sound/soundfont.h                        |    4 +-
 include/sound/tea6330t.h                         |    2 +
 include/sound/trident.h                          |    8 ++---
 include/sound/wss.h                              |    8 ++---
 include/sound/ymfpci.h                           |    8 ++---
 include/trace/events/compaction.h                |    2 +
 include/trace/events/kmem.h                      |    2 +
 include/trace/events/vmscan.h                    |    2 +
 include/xen/interface/callback.h                 |    2 +
 include/xen/interface/hvm/params.h               |    2 +
 include/xen/interface/io/blkif.h                 |    4 +-
 include/xen/interface/io/netif.h                 |    4 +-
 include/xen/interface/sched.h                    |    2 +
 include/xen/interface/version.h                  |    2 +
 159 files changed, 329 insertions(+), 329 deletions(-)

diff --git a/arch/arm/include/asm/localtimer.h b/arch/arm/include/asm/localtimer.h
index 080d74f..8c67ead 100644
--- a/arch/arm/include/asm/localtimer.h
+++ b/arch/arm/include/asm/localtimer.h
@@ -27,7 +27,7 @@ asmlinkage void do_local_timer(struct pt_regs *);
 
 #ifdef CONFIG_HAVE_ARM_TWD
 
-#include "smp_twd.h"
+#include <asm/smp_twd.h>
 
 #define local_timer_ack()	twd_timer_ack()
 
diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index ac75d08..f9629a7 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -19,7 +19,7 @@
 
 #ifndef CONFIG_MMU
 
-#include "page-nommu.h"
+#include <asm/page-nommu.h>
 
 #else
 
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 5750704..0f64e0c 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -16,7 +16,7 @@
 
 #ifndef CONFIG_MMU
 
-#include "pgtable-nommu.h"
+#include <asm/pgtable-nommu.h>
 
 #else
 
diff --git a/arch/arm/include/asm/vfpmacros.h b/arch/arm/include/asm/vfpmacros.h
index 3d5fc41..a7aadbd 100644
--- a/arch/arm/include/asm/vfpmacros.h
+++ b/arch/arm/include/asm/vfpmacros.h
@@ -5,7 +5,7 @@
  */
 #include <asm/hwcap.h>
 
-#include "vfp.h"
+#include <asm/vfp.h>
 
 @ Macros to allow building with old toolkits (with no VFP support)
 	.macro	VFPFMRX, rd, sysreg, cond
diff --git a/arch/cris/include/arch-v10/arch/sv_addr_ag.h b/arch/cris/include/arch-v10/arch/sv_addr_ag.h
index e4a6b68..5517f04 100644
--- a/arch/cris/include/arch-v10/arch/sv_addr_ag.h
+++ b/arch/cris/include/arch-v10/arch/sv_addr_ag.h
@@ -114,7 +114,7 @@
 
 /*------------------------------------------------------------*/
 
-#include "sv_addr.agh"
+#include <arch/sv_addr.agh>
 
 #if __test_sv_addr__
 /* IO_MASK( R_BUS_CONFIG , CE ) */
diff --git a/arch/cris/include/arch-v10/arch/svinto.h b/arch/cris/include/arch-v10/arch/svinto.h
index 0881a1a..da5c152 100644
--- a/arch/cris/include/arch-v10/arch/svinto.h
+++ b/arch/cris/include/arch-v10/arch/svinto.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_CRIS_SVINTO_H
 #define _ASM_CRIS_SVINTO_H
 
-#include "sv_addr_ag.h"
+#include <arch/sv_addr_ag.h>
 
 extern unsigned int genconfig_shadow; /* defined and set in head.S */
 
diff --git a/arch/cris/include/arch-v32/arch/dma.h b/arch/cris/include/arch-v32/arch/dma.h
index 6190615..6f92f4f 100644
--- a/arch/cris/include/arch-v32/arch/dma.h
+++ b/arch/cris/include/arch-v32/arch/dma.h
@@ -1 +1 @@
-#include "mach/dma.h"
+#include <mach/dma.h>
diff --git a/arch/cris/include/arch-v32/arch/hwregs/dma.h b/arch/cris/include/arch-v32/arch/hwregs/dma.h
index 3ce322b..52bf679 100644
--- a/arch/cris/include/arch-v32/arch/hwregs/dma.h
+++ b/arch/cris/include/arch-v32/arch/hwregs/dma.h
@@ -7,7 +7,7 @@
 #define dma_h
 
 /* registers */ /* Really needed, since both are listed in sw.list? */
-#include "dma_defs.h"
+#include <arch/hwregs/dma_defs.h>
 
 
 /* descriptors */
diff --git a/arch/m68k/include/asm/cacheflush.h b/arch/m68k/include/asm/cacheflush.h
index a70d731..4fc7382 100644
--- a/arch/m68k/include/asm/cacheflush.h
+++ b/arch/m68k/include/asm/cacheflush.h
@@ -1,5 +1,5 @@
 #ifdef __uClinux__
-#include "cacheflush_no.h"
+#include <asm/cacheflush_no.h>
 #else
-#include "cacheflush_mm.h"
+#include <asm/cacheflush_mm.h>
 #endif
diff --git a/arch/m68k/include/asm/entry.h b/arch/m68k/include/asm/entry.h
index 876eec6..7308daf 100644
--- a/arch/m68k/include/asm/entry.h
+++ b/arch/m68k/include/asm/entry.h
@@ -1,5 +1,5 @@
 #ifdef __uClinux__
-#include "entry_no.h"
+#include <asm/entry_no.h>
 #else
-#include "entry_mm.h"
+#include <asm/entry_mm.h>
 #endif
diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
index c7210ba..c70cc91 100644
--- a/arch/m68k/include/asm/io.h
+++ b/arch/m68k/include/asm/io.h
@@ -1,5 +1,5 @@
 #ifdef __uClinux__
-#include "io_no.h"
+#include <asm/io_no.h>
 #else
-#include "io_mm.h"
+#include <asm/io_mm.h>
 #endif
diff --git a/arch/m68k/include/asm/m68360.h b/arch/m68k/include/asm/m68360.h
index eb7d39e..4664180 100644
--- a/arch/m68k/include/asm/m68360.h
+++ b/arch/m68k/include/asm/m68360.h
@@ -1,7 +1,7 @@
-#include "m68360_regs.h"
-#include "m68360_pram.h"
-#include "m68360_quicc.h"
-#include "m68360_enet.h"
+#include <asm/m68360_regs.h>
+#include <asm/m68360_pram.h>
+#include <asm/m68360_quicc.h>
+#include <asm/m68360_enet.h>
 
 #ifdef CONFIG_M68360
 
diff --git a/arch/m68k/include/asm/m68360_enet.h b/arch/m68k/include/asm/m68360_enet.h
index c36f4d0..4d04037 100644
--- a/arch/m68k/include/asm/m68360_enet.h
+++ b/arch/m68k/include/asm/m68360_enet.h
@@ -10,7 +10,7 @@
 #ifndef __ETHER_H
 #define __ETHER_H
 
-#include "quicc_simple.h"
+#include <asm/quicc_simple.h>
 
 /*
  * transmit BD's
diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
index dfebb7c..095d829 100644
--- a/arch/m68k/include/asm/page.h
+++ b/arch/m68k/include/asm/page.h
@@ -39,9 +39,9 @@ typedef struct page *pgtable_t;
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_MMU
-#include "page_mm.h"
+#include <asm/page_mm.h>
 #else
-#include "page_no.h"
+#include <asm/page_no.h>
 #endif
 
 #include <asm-generic/getorder.h>
diff --git a/arch/m68k/include/asm/pgtable.h b/arch/m68k/include/asm/pgtable.h
index ee6759e..a3d733b 100644
--- a/arch/m68k/include/asm/pgtable.h
+++ b/arch/m68k/include/asm/pgtable.h
@@ -1,5 +1,5 @@
 #ifdef __uClinux__
-#include "pgtable_no.h"
+#include <asm/pgtable_no.h>
 #else
-#include "pgtable_mm.h"
+#include <asm/pgtable_mm.h>
 #endif
diff --git a/arch/m68k/include/asm/q40_master.h b/arch/m68k/include/asm/q40_master.h
index 3907a09..fc5b362 100644
--- a/arch/m68k/include/asm/q40_master.h
+++ b/arch/m68k/include/asm/q40_master.h
@@ -60,7 +60,7 @@
 #define Q40_RTC_WRITE  128
 
 /* define some Q40 specific ints */
-#include "q40ints.h"
+#include <asm/q40ints.h>
 
 /* misc defs */
 #define DAC_LEFT  ((unsigned char *)0xff008000)
diff --git a/arch/m68k/include/asm/uaccess.h b/arch/m68k/include/asm/uaccess.h
index 38f92db..639c731 100644
--- a/arch/m68k/include/asm/uaccess.h
+++ b/arch/m68k/include/asm/uaccess.h
@@ -1,5 +1,5 @@
 #ifdef __uClinux__
-#include "uaccess_no.h"
+#include <asm/uaccess_no.h>
 #else
-#include "uaccess_mm.h"
+#include <asm/uaccess_mm.h>
 #endif
diff --git a/arch/microblaze/include/asm/mmu_context.h b/arch/microblaze/include/asm/mmu_context.h
index 24eab16..0ccd8c4 100644
--- a/arch/microblaze/include/asm/mmu_context.h
+++ b/arch/microblaze/include/asm/mmu_context.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_MMU
-# include "mmu_context_mm.h"
+# include <asm/mmu_context_mm.h>
 #else
 # include <asm-generic/mmu_context.h>
 #endif
diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h
index 91180fa..1e08044 100644
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h
+++ b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h
@@ -1,7 +1,7 @@
 #ifndef BCM63XX_IO_H_
 #define BCM63XX_IO_H_
 
-#include "bcm63xx_cpu.h"
+#include <asm/mach-bcm63xx/bcm63xx_cpu.h>
 
 /*
  * Physical memory map, RAM is mapped at 0x0.
diff --git a/arch/mips/include/asm/mach-pnx833x/gpio.h b/arch/mips/include/asm/mach-pnx833x/gpio.h
index ed3a88d..f192acf 100644
--- a/arch/mips/include/asm/mach-pnx833x/gpio.h
+++ b/arch/mips/include/asm/mach-pnx833x/gpio.h
@@ -30,7 +30,7 @@
    - including locking between different uses
 */
 
-#include "pnx833x.h"
+#include <asm/mach-pnx833x/pnx833x.h>
 
 #define SET_REG_BIT(reg, bit)		do { (reg |= (1 << (bit))); } while (0)
 #define CLEAR_REG_BIT(reg, bit)		do { (reg &= ~(1 << (bit))); } while (0)
diff --git a/arch/mips/include/asm/octeon/cvmx-asm.h b/arch/mips/include/asm/octeon/cvmx-asm.h
index 5de5de9..31eacc2 100644
--- a/arch/mips/include/asm/octeon/cvmx-asm.h
+++ b/arch/mips/include/asm/octeon/cvmx-asm.h
@@ -32,7 +32,7 @@
 #ifndef __CVMX_ASM_H__
 #define __CVMX_ASM_H__
 
-#include "octeon-model.h"
+#include <asm/octeon/octeon-model.h>
 
 /* other useful stuff */
 #define CVMX_SYNC asm volatile ("sync" : : : "memory")
diff --git a/arch/mips/include/asm/octeon/cvmx-spinlock.h b/arch/mips/include/asm/octeon/cvmx-spinlock.h
index 2fbf087..a672abb 100644
--- a/arch/mips/include/asm/octeon/cvmx-spinlock.h
+++ b/arch/mips/include/asm/octeon/cvmx-spinlock.h
@@ -35,7 +35,7 @@
 #ifndef __CVMX_SPINLOCK_H__
 #define __CVMX_SPINLOCK_H__
 
-#include "cvmx-asm.h"
+#include <asm/octeon/cvmx-asm.h>
 
 /* Spinlocks for Octeon */
 
diff --git a/arch/mips/include/asm/octeon/cvmx.h b/arch/mips/include/asm/octeon/cvmx.h
index 7e12867..3a143a6 100644
--- a/arch/mips/include/asm/octeon/cvmx.h
+++ b/arch/mips/include/asm/octeon/cvmx.h
@@ -31,24 +31,24 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 
-#include "cvmx-asm.h"
-#include "cvmx-packet.h"
-#include "cvmx-sysinfo.h"
-
-#include "cvmx-ciu-defs.h"
-#include "cvmx-gpio-defs.h"
-#include "cvmx-iob-defs.h"
-#include "cvmx-ipd-defs.h"
-#include "cvmx-l2c-defs.h"
-#include "cvmx-l2d-defs.h"
-#include "cvmx-l2t-defs.h"
-#include "cvmx-led-defs.h"
-#include "cvmx-mio-defs.h"
-#include "cvmx-pow-defs.h"
-
-#include "cvmx-bootinfo.h"
-#include "cvmx-bootmem.h"
-#include "cvmx-l2c.h"
+#include <asm/octeon/cvmx-asm.h>
+#include <asm/octeon/cvmx-packet.h>
+#include <asm/octeon/cvmx-sysinfo.h>
+
+#include <asm/octeon/cvmx-ciu-defs.h>
+#include <asm/octeon/cvmx-gpio-defs.h>
+#include <asm/octeon/cvmx-iob-defs.h>
+#include <asm/octeon/cvmx-ipd-defs.h>
+#include <asm/octeon/cvmx-l2c-defs.h>
+#include <asm/octeon/cvmx-l2d-defs.h>
+#include <asm/octeon/cvmx-l2t-defs.h>
+#include <asm/octeon/cvmx-led-defs.h>
+#include <asm/octeon/cvmx-mio-defs.h>
+#include <asm/octeon/cvmx-pow-defs.h>
+
+#include <asm/octeon/cvmx-bootinfo.h>
+#include <asm/octeon/cvmx-bootmem.h>
+#include <asm/octeon/cvmx-l2c.h>
 
 #ifndef CVMX_ENABLE_DEBUG_PRINTS
 #define CVMX_ENABLE_DEBUG_PRINTS 1
diff --git a/arch/mips/include/asm/octeon/octeon-model.h b/arch/mips/include/asm/octeon/octeon-model.h
index 700f88e..40b81ce 100644
--- a/arch/mips/include/asm/octeon/octeon-model.h
+++ b/arch/mips/include/asm/octeon/octeon-model.h
@@ -336,6 +336,6 @@ static inline int __octeon_is_model_runtime__(uint32_t model)
 const char *octeon_model_get_string(uint32_t chip_id);
 const char *octeon_model_get_string_buffer(uint32_t chip_id, char *buffer);
 
-#include "octeon-feature.h"
+#include <asm/octeon/octeon-feature.h>
 
 #endif /* __OCTEON_MODEL_H__ */
diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index f72f768..e314b35 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_OCTEON_OCTEON_H
 #define __ASM_OCTEON_OCTEON_H
 
-#include "cvmx.h"
+#include <asm/octeon/cvmx.h>
 
 extern uint64_t octeon_bootmem_alloc_range_phys(uint64_t size,
 						uint64_t alignment,
diff --git a/arch/mips/include/asm/sibyte/bcm1480_int.h b/arch/mips/include/asm/sibyte/bcm1480_int.h
index 6109557..fffb224 100644
--- a/arch/mips/include/asm/sibyte/bcm1480_int.h
+++ b/arch/mips/include/asm/sibyte/bcm1480_int.h
@@ -34,7 +34,7 @@
 #ifndef _BCM1480_INT_H
 #define _BCM1480_INT_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  Interrupt Mapper Constants
diff --git a/arch/mips/include/asm/sibyte/bcm1480_l2c.h b/arch/mips/include/asm/sibyte/bcm1480_l2c.h
index fd75817..725d38c 100644
--- a/arch/mips/include/asm/sibyte/bcm1480_l2c.h
+++ b/arch/mips/include/asm/sibyte/bcm1480_l2c.h
@@ -33,7 +33,7 @@
 #ifndef _BCM1480_L2C_H
 #define _BCM1480_L2C_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Format of level 2 cache management address (Table 55)
diff --git a/arch/mips/include/asm/sibyte/bcm1480_mc.h b/arch/mips/include/asm/sibyte/bcm1480_mc.h
index f26a41a..4307a75 100644
--- a/arch/mips/include/asm/sibyte/bcm1480_mc.h
+++ b/arch/mips/include/asm/sibyte/bcm1480_mc.h
@@ -33,7 +33,7 @@
 #ifndef _BCM1480_MC_H
 #define _BCM1480_MC_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Memory Channel Configuration Register (Table 81)
diff --git a/arch/mips/include/asm/sibyte/bcm1480_regs.h b/arch/mips/include/asm/sibyte/bcm1480_regs.h
index b4077bb..84d168d 100644
--- a/arch/mips/include/asm/sibyte/bcm1480_regs.h
+++ b/arch/mips/include/asm/sibyte/bcm1480_regs.h
@@ -32,14 +32,14 @@
 #ifndef _BCM1480_REGS_H
 #define _BCM1480_REGS_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  Pull in the BCM1250's registers since a great deal of the 1480's
     *  functions are the same as the BCM1250.
     ********************************************************************* */
 
-#include "sb1250_regs.h"
+#include <asm/sibyte/sb1250_regs.h>
 
 
 /*  *********************************************************************
diff --git a/arch/mips/include/asm/sibyte/bcm1480_scd.h b/arch/mips/include/asm/sibyte/bcm1480_scd.h
index 25ef24c..2af3706 100644
--- a/arch/mips/include/asm/sibyte/bcm1480_scd.h
+++ b/arch/mips/include/asm/sibyte/bcm1480_scd.h
@@ -32,13 +32,13 @@
 #ifndef _BCM1480_SCD_H
 #define _BCM1480_SCD_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  Pull in the BCM1250's SCD since lots of stuff is the same.
     ********************************************************************* */
 
-#include "sb1250_scd.h"
+#include <asm/sibyte/sb1250_scd.h>
 
 /*  *********************************************************************
     *  Some general notes:
diff --git a/arch/mips/include/asm/sibyte/sb1250_dma.h b/arch/mips/include/asm/sibyte/sb1250_dma.h
index bad5617..6c44dfb 100644
--- a/arch/mips/include/asm/sibyte/sb1250_dma.h
+++ b/arch/mips/include/asm/sibyte/sb1250_dma.h
@@ -36,7 +36,7 @@
 #define _SB1250_DMA_H
 
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  DMA Registers
diff --git a/arch/mips/include/asm/sibyte/sb1250_genbus.h b/arch/mips/include/asm/sibyte/sb1250_genbus.h
index 94e9c7c..a96ded1 100644
--- a/arch/mips/include/asm/sibyte/sb1250_genbus.h
+++ b/arch/mips/include/asm/sibyte/sb1250_genbus.h
@@ -34,7 +34,7 @@
 #ifndef _SB1250_GENBUS_H
 #define _SB1250_GENBUS_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Generic Bus Region Configuration Registers (Table 11-4)
diff --git a/arch/mips/include/asm/sibyte/sb1250_int.h b/arch/mips/include/asm/sibyte/sb1250_int.h
index f2850b4..dbea73d 100644
--- a/arch/mips/include/asm/sibyte/sb1250_int.h
+++ b/arch/mips/include/asm/sibyte/sb1250_int.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_INT_H
 #define _SB1250_INT_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  Interrupt Mapper Constants
diff --git a/arch/mips/include/asm/sibyte/sb1250_l2c.h b/arch/mips/include/asm/sibyte/sb1250_l2c.h
index 6554dcf..b61a749 100644
--- a/arch/mips/include/asm/sibyte/sb1250_l2c.h
+++ b/arch/mips/include/asm/sibyte/sb1250_l2c.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_L2C_H
 #define _SB1250_L2C_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Level 2 Cache Tag register (Table 5-3)
diff --git a/arch/mips/include/asm/sibyte/sb1250_ldt.h b/arch/mips/include/asm/sibyte/sb1250_ldt.h
index 1e76cf1..bf7f320 100644
--- a/arch/mips/include/asm/sibyte/sb1250_ldt.h
+++ b/arch/mips/include/asm/sibyte/sb1250_ldt.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_LDT_H
 #define _SB1250_LDT_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 #define K_LDT_VENDOR_SIBYTE	0x166D
 #define K_LDT_DEVICE_SB1250	0x0002
diff --git a/arch/mips/include/asm/sibyte/sb1250_mac.h b/arch/mips/include/asm/sibyte/sb1250_mac.h
index 77f7872..cfc4d78 100644
--- a/arch/mips/include/asm/sibyte/sb1250_mac.h
+++ b/arch/mips/include/asm/sibyte/sb1250_mac.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_MAC_H
 #define _SB1250_MAC_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  Ethernet MAC Registers
diff --git a/arch/mips/include/asm/sibyte/sb1250_mc.h b/arch/mips/include/asm/sibyte/sb1250_mc.h
index 1eb1b5a..15048dc 100644
--- a/arch/mips/include/asm/sibyte/sb1250_mc.h
+++ b/arch/mips/include/asm/sibyte/sb1250_mc.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_MC_H
 #define _SB1250_MC_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Memory Channel Config Register (table 6-14)
diff --git a/arch/mips/include/asm/sibyte/sb1250_regs.h b/arch/mips/include/asm/sibyte/sb1250_regs.h
index 8f53ec8..29b9f0b 100644
--- a/arch/mips/include/asm/sibyte/sb1250_regs.h
+++ b/arch/mips/include/asm/sibyte/sb1250_regs.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_REGS_H
 #define _SB1250_REGS_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 
 /*  *********************************************************************
diff --git a/arch/mips/include/asm/sibyte/sb1250_scd.h b/arch/mips/include/asm/sibyte/sb1250_scd.h
index e49c3e8..615e165 100644
--- a/arch/mips/include/asm/sibyte/sb1250_scd.h
+++ b/arch/mips/include/asm/sibyte/sb1250_scd.h
@@ -32,7 +32,7 @@
 #ifndef _SB1250_SCD_H
 #define _SB1250_SCD_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*  *********************************************************************
     *  System control/debug registers
diff --git a/arch/mips/include/asm/sibyte/sb1250_smbus.h b/arch/mips/include/asm/sibyte/sb1250_smbus.h
index 0476992..128d6b7 100644
--- a/arch/mips/include/asm/sibyte/sb1250_smbus.h
+++ b/arch/mips/include/asm/sibyte/sb1250_smbus.h
@@ -34,7 +34,7 @@
 #ifndef _SB1250_SMBUS_H
 #define _SB1250_SMBUS_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * SMBus Clock Frequency Register (Table 14-2)
diff --git a/arch/mips/include/asm/sibyte/sb1250_syncser.h b/arch/mips/include/asm/sibyte/sb1250_syncser.h
index d4b8558..274e917 100644
--- a/arch/mips/include/asm/sibyte/sb1250_syncser.h
+++ b/arch/mips/include/asm/sibyte/sb1250_syncser.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_SYNCSER_H
 #define _SB1250_SYNCSER_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /*
  * Serial Mode Configuration Register
diff --git a/arch/mips/include/asm/sibyte/sb1250_uart.h b/arch/mips/include/asm/sibyte/sb1250_uart.h
index d835bf2..bb99eca 100644
--- a/arch/mips/include/asm/sibyte/sb1250_uart.h
+++ b/arch/mips/include/asm/sibyte/sb1250_uart.h
@@ -33,7 +33,7 @@
 #ifndef _SB1250_UART_H
 #define _SB1250_UART_H
 
-#include "sb1250_defs.h"
+#include <asm/sibyte/sb1250_defs.h>
 
 /* **********************************************************************
    * DUART Registers
diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index 7f065e1..0e15db4 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -24,7 +24,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/device.h>
-#include "cell-pmu.h"
+#include <asm/cell-pmu.h>
 
 union ps3_firmware_version {
 	u64 raw;
diff --git a/arch/powerpc/include/asm/ucc_fast.h b/arch/powerpc/include/asm/ucc_fast.h
index 839aab8..4644c84 100644
--- a/arch/powerpc/include/asm/ucc_fast.h
+++ b/arch/powerpc/include/asm/ucc_fast.h
@@ -19,7 +19,7 @@
 #include <asm/immap_qe.h>
 #include <asm/qe.h>
 
-#include "ucc.h"
+#include <asm/ucc.h>
 
 /* Receive BD's status */
 #define R_E	0x80000000	/* buffer empty */
diff --git a/arch/powerpc/include/asm/ucc_slow.h b/arch/powerpc/include/asm/ucc_slow.h
index 0980e6a..cf131ff 100644
--- a/arch/powerpc/include/asm/ucc_slow.h
+++ b/arch/powerpc/include/asm/ucc_slow.h
@@ -20,7 +20,7 @@
 #include <asm/immap_qe.h>
 #include <asm/qe.h>
 
-#include "ucc.h"
+#include <asm/ucc.h>
 
 /* transmit BD's status */
 #define T_R	0x80000000	/* ready bit */
diff --git a/arch/sh/include/asm/checksum.h b/arch/sh/include/asm/checksum.h
index fc26d1f..34ae262 100644
--- a/arch/sh/include/asm/checksum.h
+++ b/arch/sh/include/asm/checksum.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_SUPERH32
-# include "checksum_32.h"
+# include <asm/checksum_32.h>
 #else
 # include <asm-generic/checksum.h>
 #endif
diff --git a/arch/sh/include/asm/mmu_context.h b/arch/sh/include/asm/mmu_context.h
index 384c747..21c5088 100644
--- a/arch/sh/include/asm/mmu_context.h
+++ b/arch/sh/include/asm/mmu_context.h
@@ -46,9 +46,9 @@
 #define MMU_VPN_MASK	0xfffff000
 
 #if defined(CONFIG_SUPERH32)
-#include "mmu_context_32.h"
+#include <asm/mmu_context_32.h>
 #else
-#include "mmu_context_64.h"
+#include <asm/mmu_context_64.h>
 #endif
 
 /*
diff --git a/arch/sh/include/asm/posix_types.h b/arch/sh/include/asm/posix_types.h
index 4eeb723..f08449b 100644
--- a/arch/sh/include/asm/posix_types.h
+++ b/arch/sh/include/asm/posix_types.h
@@ -1,13 +1,13 @@
 #ifdef __KERNEL__
 # ifdef CONFIG_SUPERH32
-#  include "posix_types_32.h"
+#  include <asm/posix_types_32.h>
 # else
-#  include "posix_types_64.h"
+#  include <asm/posix_types_64.h>
 # endif
 #else
 # ifdef __SH5__
-#  include "posix_types_64.h"
+#  include <asm/posix_types_64.h>
 # else
-#  include "posix_types_32.h"
+#  include <asm/posix_types_32.h>
 # endif
 #endif /* __KERNEL__ */
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 9c7bdfc..9dc9475 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -164,9 +164,9 @@ int vsyscall_init(void);
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_SUPERH32
-# include "processor_32.h"
+# include <asm/processor_32.h>
 #else
-# include "processor_64.h"
+# include <asm/processor_64.h>
 #endif
 
 #endif /* __ASM_SH_PROCESSOR_H */
diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index b97baf8..78a1cd6 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -25,9 +25,9 @@
 #define PT_TEXT_LEN		252
 
 #if defined(__SH5__) || defined(CONFIG_CPU_SH5)
-#include "ptrace_64.h"
+#include <asm/ptrace_64.h>
 #else
-#include "ptrace_32.h"
+#include <asm/ptrace_32.h>
 #endif
 
 #ifdef __KERNEL__
diff --git a/arch/sh/include/asm/string.h b/arch/sh/include/asm/string.h
index 8c1ea21d..114011f 100644
--- a/arch/sh/include/asm/string.h
+++ b/arch/sh/include/asm/string.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_SUPERH32
-# include "string_32.h"
+# include <asm/string_32.h>
 #else
-# include "string_64.h"
+# include <asm/string_64.h>
 #endif
diff --git a/arch/sh/include/asm/syscall.h b/arch/sh/include/asm/syscall.h
index aa7777b..847128d 100644
--- a/arch/sh/include/asm/syscall.h
+++ b/arch/sh/include/asm/syscall.h
@@ -4,9 +4,9 @@
 extern const unsigned long sys_call_table[];
 
 #ifdef CONFIG_SUPERH32
-# include "syscall_32.h"
+# include <asm/syscall_32.h>
 #else
-# include "syscall_64.h"
+# include <asm/syscall_64.h>
 #endif
 
 #endif /* __ASM_SH_SYSCALL_H */
diff --git a/arch/sh/include/asm/syscalls.h b/arch/sh/include/asm/syscalls.h
index 507725a..3dbfef0 100644
--- a/arch/sh/include/asm/syscalls.h
+++ b/arch/sh/include/asm/syscalls.h
@@ -11,9 +11,9 @@ asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long fd, unsigned long pgoff);
 
 #ifdef CONFIG_SUPERH32
-# include "syscalls_32.h"
+# include <asm/syscalls_32.h>
 #else
-# include "syscalls_64.h"
+# include <asm/syscalls_64.h>
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
index 10c8b18..507d082 100644
--- a/arch/sh/include/asm/system.h
+++ b/arch/sh/include/asm/system.h
@@ -176,9 +176,9 @@ struct mem_access {
 };
 
 #ifdef CONFIG_SUPERH32
-# include "system_32.h"
+# include <asm/system_32.h>
 #else
-# include "system_64.h"
+# include <asm/system_64.h>
 #endif
 
 #endif
diff --git a/arch/sh/include/asm/tlb.h b/arch/sh/include/asm/tlb.h
index ec88bfc..e61d43d 100644
--- a/arch/sh/include/asm/tlb.h
+++ b/arch/sh/include/asm/tlb.h
@@ -2,7 +2,7 @@
 #define __ASM_SH_TLB_H
 
 #ifdef CONFIG_SUPERH64
-# include "tlb_64.h"
+# include <asm/tlb_64.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/sh/include/asm/uaccess.h b/arch/sh/include/asm/uaccess.h
index 075848f..ee4cf16 100644
--- a/arch/sh/include/asm/uaccess.h
+++ b/arch/sh/include/asm/uaccess.h
@@ -95,9 +95,9 @@ struct __large_struct { unsigned long buf[100]; };
 })
 
 #ifdef CONFIG_SUPERH32
-# include "uaccess_32.h"
+# include <asm/uaccess_32.h>
 #else
-# include "uaccess_64.h"
+# include <asm/uaccess_64.h>
 #endif
 
 /* Generic arbitrary sized copy.  */
diff --git a/arch/sh/include/asm/unistd.h b/arch/sh/include/asm/unistd.h
index 65be656..5e845e8 100644
--- a/arch/sh/include/asm/unistd.h
+++ b/arch/sh/include/asm/unistd.h
@@ -1,13 +1,13 @@
 #ifdef __KERNEL__
 # ifdef CONFIG_SUPERH32
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # else
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # endif
 #else
 # ifdef __SH5__
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # else
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # endif
 #endif
diff --git a/arch/sh/include/mach-ecovec24/mach/romimage.h b/arch/sh/include/mach-ecovec24/mach/romimage.h
index d63ef51..60f3e8a 100644
--- a/arch/sh/include/mach-ecovec24/mach/romimage.h
+++ b/arch/sh/include/mach-ecovec24/mach/romimage.h
@@ -6,7 +6,7 @@
  */
 
 #include <asm/romimage-macros.h>
-#include "partner-jet-setup.txt"
+#include <mach/partner-jet-setup.txt>
 
 	/* execute icbi after enabling cache */
 	mov.l	1f, r0
diff --git a/arch/sh/include/mach-kfr2r09/mach/romimage.h b/arch/sh/include/mach-kfr2r09/mach/romimage.h
index 7a88316..1afae21 100644
--- a/arch/sh/include/mach-kfr2r09/mach/romimage.h
+++ b/arch/sh/include/mach-kfr2r09/mach/romimage.h
@@ -6,7 +6,7 @@
  */
 
 #include <asm/romimage-macros.h>
-#include "partner-jet-setup.txt"
+#include <mach/partner-jet-setup.txt>
 
 	/* execute icbi after enabling cache */
 	mov.l	1f, r0
diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
index 8040d57..46705af 100644
--- a/arch/unicore32/include/mach/PKUnity.h
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -15,7 +15,7 @@
 #error You must include hardware.h not PKUnity.h
 #endif
 
-#include "bitfield.h"
+#include <mach/bitfield.h>
 
 /*
  * Memory Definitions
@@ -32,7 +32,7 @@
  * 0x98000000 - 0x9FFFFFFF 128MB  PCI PCI-AHB MEM-mapping
  */
 #define PKUNITY_PCI_BASE		io_p2v(0x80000000) /* 0x80000000 - 0xBFFFFFFF 1GB */
-#include "regs-pci.h"
+#include <mach/regs-pci.h>
 
 #define PKUNITY_PCICFG_BASE		(PKUNITY_PCI_BASE + 0x0)
 #define PKUNITY_PCIBRI_BASE		(PKUNITY_PCI_BASE + 0x00010000)
@@ -50,18 +50,18 @@
 #define PKUNITY_ARBITER_BASE		(PKUNITY_AHB_BASE + 0x000000) /* AHB-2 */
 #define PKUNITY_DDR2CTRL_BASE		(PKUNITY_AHB_BASE + 0x100000) /* AHB-3 */
 #define PKUNITY_DMAC_BASE		(PKUNITY_AHB_BASE + 0x200000) /* AHB-4 */
-#include "regs-dmac.h"
+#include <mach/regs-dmac.h>
 #define PKUNITY_UMAL_BASE		(PKUNITY_AHB_BASE + 0x300000) /* AHB-5 */
-#include "regs-umal.h"
+#include <mach/regs-umal.h>
 #define PKUNITY_USB_BASE		(PKUNITY_AHB_BASE + 0x400000) /* AHB-6 */
 #define PKUNITY_SATA_BASE		(PKUNITY_AHB_BASE + 0x500000) /* AHB-7 */
 #define PKUNITY_SMC_BASE		(PKUNITY_AHB_BASE + 0x600000) /* AHB-8 */
 /* AHB-9 is for APB bridge */
 #define PKUNITY_MME_BASE		(PKUNITY_AHB_BASE + 0x700000) /* AHB-10 */
 #define PKUNITY_UNIGFX_BASE		(PKUNITY_AHB_BASE + 0x800000) /* AHB-11 */
-#include "regs-unigfx.h"
+#include <mach/regs-unigfx.h>
 #define PKUNITY_NAND_BASE		(PKUNITY_AHB_BASE + 0x900000) /* AHB-12 */
-#include "regs-nand.h"
+#include <mach/regs-nand.h>
 #define PKUNITY_H264D_BASE		(PKUNITY_AHB_BASE + 0xA00000) /* AHB-13 */
 #define PKUNITY_H264E_BASE		(PKUNITY_AHB_BASE + 0xB00000) /* AHB-14 */
 
@@ -72,27 +72,27 @@
 
 #define PKUNITY_UART0_BASE		(PKUNITY_APB_BASE + 0x000000) /* APB-0 */
 #define PKUNITY_UART1_BASE		(PKUNITY_APB_BASE + 0x100000) /* APB-1 */
-#include "regs-uart.h"
+#include <mach/regs-uart.h>
 #define PKUNITY_I2C_BASE		(PKUNITY_APB_BASE + 0x200000) /* APB-2 */
-#include "regs-i2c.h"
+#include <mach/regs-i2c.h>
 #define PKUNITY_SPI_BASE		(PKUNITY_APB_BASE + 0x300000) /* APB-3 */
-#include "regs-spi.h"
+#include <mach/regs-spi.h>
 #define PKUNITY_AC97_BASE		(PKUNITY_APB_BASE + 0x400000) /* APB-4 */
-#include "regs-ac97.h"
+#include <mach/regs-ac97.h>
 #define PKUNITY_GPIO_BASE		(PKUNITY_APB_BASE + 0x500000) /* APB-5 */
-#include "regs-gpio.h"
+#include <mach/regs-gpio.h>
 #define PKUNITY_INTC_BASE		(PKUNITY_APB_BASE + 0x600000) /* APB-6 */
-#include "regs-intc.h"
+#include <mach/regs-intc.h>
 #define PKUNITY_RTC_BASE		(PKUNITY_APB_BASE + 0x700000) /* APB-7 */
-#include "regs-rtc.h"
+#include <mach/regs-rtc.h>
 #define PKUNITY_OST_BASE		(PKUNITY_APB_BASE + 0x800000) /* APB-8 */
-#include "regs-ost.h"
+#include <mach/regs-ost.h>
 #define PKUNITY_RESETC_BASE		(PKUNITY_APB_BASE + 0x900000) /* APB-9 */
-#include "regs-resetc.h"
+#include <mach/regs-resetc.h>
 #define PKUNITY_PM_BASE			(PKUNITY_APB_BASE + 0xA00000) /* APB-10 */
-#include "regs-pm.h"
+#include <mach/regs-pm.h>
 #define PKUNITY_PS2_BASE		(PKUNITY_APB_BASE + 0xB00000) /* APB-11 */
-#include "regs-ps2.h"
+#include <mach/regs-ps2.h>
 #define PKUNITY_SDC_BASE		(PKUNITY_APB_BASE + 0xC00000) /* APB-12 */
-#include "regs-sdc.h"
+#include <mach/regs-sdc.h>
 
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index 930bea6..9e20b5d 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -15,7 +15,7 @@
 #ifndef __MACH_PUV3_HARDWARE_H__
 #define __MACH_PUV3_HARDWARE_H__
 
-#include "PKUnity.h"
+#include <mach/PKUnity.h>
 
 #ifndef __ASSEMBLY__
 #define io_p2v(x)	(void __iomem *)((x) - PKUNITY_MMIO_BASE)
diff --git a/arch/unicore32/include/mach/uncompress.h b/arch/unicore32/include/mach/uncompress.h
index 142d3e7..9be67c9 100644
--- a/arch/unicore32/include/mach/uncompress.h
+++ b/arch/unicore32/include/mach/uncompress.h
@@ -13,8 +13,8 @@
 #ifndef __MACH_PUV3_UNCOMPRESS_H__
 #define __MACH_PUV3_UNCOMPRESS_H__
 
-#include "hardware.h"
-#include "ocd.h"
+#include <mach/hardware.h>
+#include <mach/ocd.h>
 
 extern char input_data[];
 extern char input_data_end[];
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 10572e3..365f653 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -313,9 +313,9 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 #define smp_mb__after_atomic_inc()	barrier()
 
 #ifdef CONFIG_X86_32
-# include "atomic64_32.h"
+# include <asm/atomic64_32.h>
 #else
-# include "atomic64_64.h"
+# include <asm/atomic64_64.h>
 #endif
 
 #endif /* _ASM_X86_ATOMIC_H */
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index a9e3a74..3742210 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -46,7 +46,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 */
 
-#include "dwarf2.h"
+#include <asm/dwarf2.h>
 
 /*
  * 64-bit system call stack frame layout defines and helpers, for
diff --git a/arch/x86/include/asm/checksum.h b/arch/x86/include/asm/checksum.h
index 848850f..5f5bb0f 100644
--- a/arch/x86/include/asm/checksum.h
+++ b/arch/x86/include/asm/checksum.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "checksum_32.h"
+# include <asm/checksum_32.h>
 #else
-# include "checksum_64.h"
+# include <asm/checksum_64.h>
 #endif
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index a460fa0..ed14064 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "cmpxchg_32.h"
+# include <asm/cmpxchg_32.h>
 #else
-# include "cmpxchg_64.h"
+# include <asm/cmpxchg_64.h>
 #endif
diff --git a/arch/x86/include/asm/mmzone.h b/arch/x86/include/asm/mmzone.h
index 64217ea..d497bc4 100644
--- a/arch/x86/include/asm/mmzone.h
+++ b/arch/x86/include/asm/mmzone.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "mmzone_32.h"
+# include <asm/mmzone_32.h>
 #else
-# include "mmzone_64.h"
+# include <asm/mmzone_64.h>
 #endif
diff --git a/arch/x86/include/asm/mutex.h b/arch/x86/include/asm/mutex.h
index a731b9c..7d3a482 100644
--- a/arch/x86/include/asm/mutex.h
+++ b/arch/x86/include/asm/mutex.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "mutex_32.h"
+# include <asm/mutex_32.h>
 #else
-# include "mutex_64.h"
+# include <asm/mutex_64.h>
 #endif
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index bfacd2c..49119fc 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -53,9 +53,9 @@ static inline int numa_cpu_node(int cpu)
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_X86_32
-# include "numa_32.h"
+# include <asm/numa_32.h>
 #else
-# include "numa_64.h"
+# include <asm/numa_64.h>
 #endif
 
 #ifdef CONFIG_NUMA
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d498943..65de77d 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -132,7 +132,7 @@ void default_teardown_msi_irqs(struct pci_dev *dev);
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
-#include "pci_64.h"
+#include <asm/pci_64.h>
 #endif
 
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 18601c8..fe8576b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -384,9 +384,9 @@ pte_t *populate_extra_pte(unsigned long vaddr);
 #endif	/* __ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
-# include "pgtable_32.h"
+# include <asm/pgtable_32.h>
 #else
-# include "pgtable_64.h"
+# include <asm/pgtable_64.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..4f57b27 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -174,9 +174,9 @@
 #endif
 
 #ifdef CONFIG_X86_32
-# include "pgtable_32_types.h"
+# include <asm/pgtable_32_types.h>
 #else
-# include "pgtable_64_types.h"
+# include <asm/pgtable_64_types.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/posix_types.h b/arch/x86/include/asm/posix_types.h
index bb7133d..8ddf6f5 100644
--- a/arch/x86/include/asm/posix_types.h
+++ b/arch/x86/include/asm/posix_types.h
@@ -1,13 +1,13 @@
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
-#  include "posix_types_32.h"
+#  include <asm/posix_types_32.h>
 # else
-#  include "posix_types_64.h"
+#  include <asm/posix_types_64.h>
 # endif
 #else
 # ifdef __i386__
-#  include "posix_types_32.h"
+#  include <asm/posix_types_32.h>
 # else
-#  include "posix_types_64.h"
+#  include <asm/posix_types_64.h>
 # endif
 #endif
diff --git a/arch/x86/include/asm/seccomp.h b/arch/x86/include/asm/seccomp.h
index c62e58a..0f3d7f0 100644
--- a/arch/x86/include/asm/seccomp.h
+++ b/arch/x86/include/asm/seccomp.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "seccomp_32.h"
+# include <asm/seccomp_32.h>
 #else
-# include "seccomp_64.h"
+# include <asm/seccomp_64.h>
 #endif
diff --git a/arch/x86/include/asm/string.h b/arch/x86/include/asm/string.h
index 6dfd6d9..09224d7 100644
--- a/arch/x86/include/asm/string.h
+++ b/arch/x86/include/asm/string.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "string_32.h"
+# include <asm/string_32.h>
 #else
-# include "string_64.h"
+# include <asm/string_64.h>
 #endif
diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
index 9bd521f..2fab6c2 100644
--- a/arch/x86/include/asm/suspend.h
+++ b/arch/x86/include/asm/suspend.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_X86_32
-# include "suspend_32.h"
+# include <asm/suspend_32.h>
 #else
-# include "suspend_64.h"
+# include <asm/suspend_64.h>
 #endif
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 36361bf..3011cc5 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -570,9 +570,9 @@ extern struct movsl_mask {
 #define ARCH_HAS_NOCACHE_UACCESS 1
 
 #ifdef CONFIG_X86_32
-# include "uaccess_32.h"
+# include <asm/uaccess_32.h>
 #else
-# include "uaccess_64.h"
+# include <asm/uaccess_64.h>
 #endif
 
 #endif /* _ASM_X86_UACCESS_H */
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..762be46 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,13 @@
 #ifdef __KERNEL__
 # ifdef CONFIG_X86_32
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # else
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # endif
 #else
 # ifdef __i386__
-#  include "unistd_32.h"
+#  include <asm/unistd_32.h>
 # else
-#  include "unistd_64.h"
+#  include <asm/unistd_64.h>
 # endif
 #endif
diff --git a/arch/x86/include/asm/user.h b/arch/x86/include/asm/user.h
index 24532c7..ccab4af 100644
--- a/arch/x86/include/asm/user.h
+++ b/arch/x86/include/asm/user.h
@@ -2,9 +2,9 @@
 #define _ASM_X86_USER_H
 
 #ifdef CONFIG_X86_32
-# include "user_32.h"
+# include <asm/user_32.h>
 #else
-# include "user_64.h"
+# include <asm/user_64.h>
 #endif
 
 #include <asm/types.h>
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 5d4922a..b85afb6 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -114,9 +114,9 @@ struct arch_shared_info {
 #endif	/* !__ASSEMBLY__ */
 
 #ifdef CONFIG_X86_32
-#include "interface_32.h"
+#include <asm/xen/interface_32.h>
 #else
-#include "interface_64.h"
+#include <asm/xen/interface_64.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index 7fcf6f3..f8fde90 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -3,8 +3,8 @@
 # include <asm-generic/xor.h>
 #else
 #ifdef CONFIG_X86_32
-# include "xor_32.h"
+# include <asm/xor_32.h>
 #else
-# include "xor_64.h"
+# include <asm/xor_64.h>
 #endif
 #endif
diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
index de39915..b187b49 100644
--- a/include/acpi/acpi.h
+++ b/include/acpi/acpi.h
@@ -53,14 +53,14 @@
  *
  * Note: The order of these include files is important.
  */
-#include "platform/acenv.h"	/* Environment-specific items */
-#include "acnames.h"		/* Common ACPI names and strings */
-#include "actypes.h"		/* ACPICA data types and structures */
-#include "acexcep.h"		/* ACPICA exceptions */
-#include "actbl.h"		/* ACPI table definitions */
-#include "acoutput.h"		/* Error output and Debug macros */
-#include "acrestyp.h"		/* Resource Descriptor structs */
-#include "acpiosxf.h"		/* OSL interfaces (ACPICA-to-OS) */
-#include "acpixf.h"		/* ACPI core subsystem external interfaces */
+#include <acpi/platform/acenv.h>	/* Environment-specific items */
+#include <acpi/acnames.h>		/* Common ACPI names and strings */
+#include <acpi/actypes.h>		/* ACPICA data types and structures */
+#include <acpi/acexcep.h>		/* ACPICA exceptions */
+#include <acpi/actbl.h>		/* ACPI table definitions */
+#include <acpi/acoutput.h>		/* Error output and Debug macros */
+#include <acpi/acrestyp.h>		/* Resource Descriptor structs */
+#include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
+#include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
 
 #endif				/* __ACPI_H__ */
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 4543b6f..cb68ea3 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -47,8 +47,8 @@
 #ifndef __ACPIOSXF_H__
 #define __ACPIOSXF_H__
 
-#include "platform/acenv.h"
-#include "actypes.h"
+#include <acpi/platform/acenv.h>
+#include <acpi/actypes.h>
 
 /* Types for acpi_os_execute */
 
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 2ed0a84..dae6451 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -49,8 +49,8 @@
 
 #define ACPI_CA_VERSION                 0x20110413
 
-#include "actypes.h"
-#include "actbl.h"
+#include <acpi/actypes.h>
+#include <acpi/actbl.h>
 
 extern u8 acpi_gbl_permanent_mmap;
 
diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
index 5af3ed5..f6cb696 100644
--- a/include/acpi/platform/acenv.h
+++ b/include/acpi/platform/acenv.h
@@ -138,7 +138,7 @@
 /*! [Begin] no source code translation */
 
 #if defined(_LINUX) || defined(__linux__)
-#include "aclinux.h"
+#include <acpi/platform/aclinux.h>
 
 #elif defined(_AED_EFI)
 #include "acefi.h"
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f72403c..9d7ad3f 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -108,7 +108,7 @@
 
 /* Linux uses GCC */
 
-#include "acgcc.h"
+#include <acpi/platform/acgcc.h>
 
 
 #ifdef __KERNEL__
diff --git a/include/drm/drm.h b/include/drm/drm.h
index 4be33b4..cc23e0f 100644
--- a/include/drm/drm.h
+++ b/include/drm/drm.h
@@ -617,7 +617,7 @@ struct drm_get_cap {
 	__u64 value;
 };
 
-#include "drm_mode.h"
+#include <drm/drm_mode.h>
 
 #define DRM_IOCTL_BASE			'd'
 #define DRM_IO(nr)			_IO(DRM_IOCTL_BASE,nr)
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 9b7c2bb..6fd0f16 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -73,7 +73,7 @@
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <asm/pgalloc.h>
-#include "drm.h"
+#include <drm/drm.h>
 
 #include <linux/idr.h>
 
@@ -83,9 +83,9 @@
 struct drm_file;
 struct drm_device;
 
-#include "drm_os_linux.h"
-#include "drm_hashtab.h"
-#include "drm_mm.h"
+#include <drm/drm_os_linux.h>
+#include <drm/drm_hashtab.h>
+#include <drm/drm_mm.h>
 
 #define DRM_UT_CORE 		0x01
 #define DRM_UT_DRIVER		0x02
@@ -653,7 +653,7 @@ struct drm_gem_object {
 	void *driver_private;
 };
 
-#include "drm_crtc.h"
+#include <drm/drm_crtc.h>
 
 /* per-master structure */
 struct drm_master {
@@ -1260,7 +1260,7 @@ extern void drm_vm_close_locked(struct vm_area_struct *vma);
 extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);
 
 				/* Memory management support (drm_memory.h) */
-#include "drm_memory.h"
+#include <drm/drm_memory.h>
 extern void drm_mem_init(void);
 extern int drm_mem_info(char *buf, char **start, off_t offset,
 			int request, int *eof, void *data);
@@ -1548,7 +1548,7 @@ void drm_gem_vm_open(struct vm_area_struct *vma);
 void drm_gem_vm_close(struct vm_area_struct *vma);
 int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 
-#include "drm_global.h"
+#include <drm/drm_global.h>
 
 static inline void
 drm_gem_object_reference(struct drm_gem_object *obj)
@@ -1654,7 +1654,7 @@ static __inline__ void drm_core_dropmap(struct drm_local_map *map)
 {
 }
 
-#include "drm_mem_util.h"
+#include <drm/drm_mem_util.h>
 
 extern int drm_fill_in_dev(struct drm_device *dev,
 			   const struct pci_device_id *ent,
diff --git a/include/drm/drm_buffer.h b/include/drm/drm_buffer.h
index 322dbff..c80d3a3 100644
--- a/include/drm/drm_buffer.h
+++ b/include/drm/drm_buffer.h
@@ -35,7 +35,7 @@
 #ifndef _DRM_BUFFER_H_
 #define _DRM_BUFFER_H_
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 struct drm_buffer {
 	int iterator;
diff --git a/include/drm/drm_encoder_slave.h b/include/drm/drm_encoder_slave.h
index 2f65633..a8d8053 100644
--- a/include/drm/drm_encoder_slave.h
+++ b/include/drm/drm_encoder_slave.h
@@ -27,8 +27,8 @@
 #ifndef __DRM_ENCODER_SLAVE_H__
 #define __DRM_ENCODER_SLAVE_H__
 
-#include "drmP.h"
-#include "drm_crtc.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
 
 /**
  * struct drm_encoder_slave_funcs - Entry points exposed by a slave encoder driver
diff --git a/include/drm/drm_memory.h b/include/drm/drm_memory.h
index 15af9b3..4baf57a 100644
--- a/include/drm/drm_memory.h
+++ b/include/drm/drm_memory.h
@@ -35,7 +35,7 @@
 
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Cut down version of drm_memory_debug.h, which used to be called
diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
index ee5389d..d3aedc9 100644
--- a/include/drm/drm_sarea.h
+++ b/include/drm/drm_sarea.h
@@ -32,7 +32,7 @@
 #ifndef _DRM_SAREA_H_
 #define _DRM_SAREA_H_
 
-#include "drm.h"
+#include <drm/drm.h>
 
 /* SAREA area needs to be at least a page */
 #if defined(__alpha__)
diff --git a/include/drm/drm_sman.h b/include/drm/drm_sman.h
index 08ecf83..d333112 100644
--- a/include/drm/drm_sman.h
+++ b/include/drm/drm_sman.h
@@ -39,8 +39,8 @@
 #ifndef DRM_SMAN_H
 #define DRM_SMAN_H
 
-#include "drmP.h"
-#include "drm_hashtab.h"
+#include <drm/drmP.h>
+#include <drm/drm_hashtab.h>
 
 /*
  * A class that is an abstration of a simple memory allocator.
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index c4d6dbf..e458c1f 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -27,7 +27,7 @@
 #ifndef _I915_DRM_H_
 #define _I915_DRM_H_
 
-#include "drm.h"
+#include <drm/drm.h>
 
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
index fca8170..2375bfd 100644
--- a/include/drm/mga_drm.h
+++ b/include/drm/mga_drm.h
@@ -35,7 +35,7 @@
 #ifndef __MGA_DRM_H__
 #define __MGA_DRM_H__
 
-#include "drm.h"
+#include <drm/drm.h>
 
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the Xserver file (mga_sarea.h)
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index b65be60..1e182d0 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -33,7 +33,7 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
-#include "drm.h"
+#include <drm/drm.h>
 
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (radeon_sarea.h)
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 42e3469..6018c08 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -31,7 +31,7 @@
 #ifndef _TTM_BO_API_H_
 #define _TTM_BO_API_H_
 
-#include "drm_hashtab.h"
+#include <drm/drm_hashtab.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/wait.h>
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 94eb143..fa435d9 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -30,14 +30,14 @@
 #ifndef _TTM_BO_DRIVER_H_
 #define _TTM_BO_DRIVER_H_
 
-#include "ttm/ttm_bo_api.h"
-#include "ttm/ttm_memory.h"
-#include "ttm/ttm_module.h"
-#include "drm_mm.h"
-#include "drm_global.h"
-#include "linux/workqueue.h"
-#include "linux/fs.h"
-#include "linux/spinlock.h"
+#include <ttm/ttm_bo_api.h>
+#include <ttm/ttm_memory.h>
+#include <ttm/ttm_module.h>
+#include <drm/drm_mm.h>
+#include <drm/drm_global.h>
+#include <linux/workqueue.h>
+#include <linux/fs.h>
+#include <linux/spinlock.h>
 
 struct ttm_backend;
 
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
index 26cc7f9..1926cae 100644
--- a/include/drm/ttm/ttm_execbuf_util.h
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -31,7 +31,7 @@
 #ifndef _TTM_EXECBUF_UTIL_H_
 #define _TTM_EXECBUF_UTIL_H_
 
-#include "ttm/ttm_bo_api.h"
+#include <ttm/ttm_bo_api.h>
 #include <linux/list.h>
 
 /**
diff --git a/include/drm/ttm/ttm_lock.h b/include/drm/ttm/ttm_lock.h
index 2e7f0c9..2902beb 100644
--- a/include/drm/ttm/ttm_lock.h
+++ b/include/drm/ttm/ttm_lock.h
@@ -49,7 +49,7 @@
 #ifndef _TTM_LOCK_H_
 #define _TTM_LOCK_H_
 
-#include "ttm/ttm_object.h"
+#include <ttm/ttm_object.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
 
diff --git a/include/drm/ttm/ttm_object.h b/include/drm/ttm/ttm_object.h
index e46054e..b01c563 100644
--- a/include/drm/ttm/ttm_object.h
+++ b/include/drm/ttm/ttm_object.h
@@ -38,7 +38,7 @@
 #define _TTM_OBJECT_H_
 
 #include <linux/list.h>
-#include "drm_hashtab.h"
+#include <drm/drm_hashtab.h>
 #include <linux/kref.h>
 #include <ttm/ttm_memory.h>
 
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 129de12..4963407 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -26,8 +26,8 @@
 #ifndef TTM_PAGE_ALLOC
 #define TTM_PAGE_ALLOC
 
-#include "ttm_bo_driver.h"
-#include "ttm_memory.h"
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_memory.h>
 
 /**
  * Get count number of pages from pool to pages list.
diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
index fd11a5b..45bc80c 100644
--- a/include/drm/via_drm.h
+++ b/include/drm/via_drm.h
@@ -24,7 +24,7 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
-#include "drm.h"
+#include <drm/drm.h>
 
 /* WARNING: These defines must be the same as what the Xserver uses.
  * if you change them, you must change the defines in the Xserver.
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8c96654..ca0f130 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -8,7 +8,7 @@
 #include <linux/bcma/bcma_driver_pci.h>
 #include <linux/ssb/ssb.h> /* SPROM sharing */
 
-#include "bcma_regs.h"
+#include <linux/bcma/bcma_regs.h>
 
 struct bcma_device;
 struct bcma_bus;
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index b8c6069..b8d618a 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -12,8 +12,8 @@
 #ifndef CEPH_FS_H
 #define CEPH_FS_H
 
-#include "msgr.h"
-#include "rados.h"
+#include <linux/ceph/msgr.h>
+#include <linux/ceph/rados.h>
 
 /*
  * subprotocol versions.  when specific messages types or high-level
diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index 2a79702..1df086d 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -1,8 +1,8 @@
 #ifndef _FS_CEPH_DEBUGFS_H
 #define _FS_CEPH_DEBUGFS_H
 
-#include "ceph_debug.h"
-#include "types.h"
+#include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/types.h>
 
 #define CEPH_DEFINE_SHOW_FUNC(name)					\
 static int name##_open(struct inode *inode, struct file *file)		\
diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index c5b6939..930441d 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -4,7 +4,7 @@
 #include <asm/unaligned.h>
 #include <linux/time.h>
 
-#include "types.h"
+#include <linux/ceph/types.h>
 
 /*
  * in all cases,
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 5637551..fcf3370 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -1,7 +1,7 @@
 #ifndef _FS_CEPH_LIBCEPH_H
 #define _FS_CEPH_LIBCEPH_H
 
-#include "ceph_debug.h"
+#include <linux/ceph/ceph_debug.h>
 
 #include <asm/unaligned.h>
 #include <linux/backing-dev.h>
@@ -14,12 +14,12 @@
 #include <linux/writeback.h>
 #include <linux/slab.h>
 
-#include "types.h"
-#include "messenger.h"
-#include "msgpool.h"
-#include "mon_client.h"
-#include "osd_client.h"
-#include "ceph_fs.h"
+#include <linux/ceph/types.h>
+#include <linux/ceph/messenger.h>
+#include <linux/ceph/msgpool.h>
+#include <linux/ceph/mon_client.h>
+#include <linux/ceph/osd_client.h>
+#include <linux/ceph/ceph_fs.h>
 
 /*
  * Supported features
diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
index 4c5cb08..3abff9e 100644
--- a/include/linux/ceph/mdsmap.h
+++ b/include/linux/ceph/mdsmap.h
@@ -1,7 +1,7 @@
 #ifndef _FS_CEPH_MDSMAP_H
 #define _FS_CEPH_MDSMAP_H
 
-#include "types.h"
+#include <linux/ceph/types.h>
 
 /*
  * mds map - describe servers in the mds cluster.
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index d7adf15..9474077 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -9,8 +9,8 @@
 #include <linux/version.h>
 #include <linux/workqueue.h>
 
-#include "types.h"
-#include "buffer.h"
+#include <linux/ceph/types.h>
+#include <linux/ceph/buffer.h>
 
 struct ceph_msg;
 struct ceph_connection;
diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index 545f859..6b80e63 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -5,7 +5,7 @@
 #include <linux/kref.h>
 #include <linux/rbtree.h>
 
-#include "messenger.h"
+#include <linux/ceph/messenger.h>
 
 struct ceph_client;
 struct ceph_mount_args;
diff --git a/include/linux/ceph/msgpool.h b/include/linux/ceph/msgpool.h
index a362605..0d92733 100644
--- a/include/linux/ceph/msgpool.h
+++ b/include/linux/ceph/msgpool.h
@@ -2,7 +2,7 @@
 #define _FS_CEPH_MSGPOOL
 
 #include <linux/mempool.h>
-#include "messenger.h"
+#include <linux/ceph/messenger.h>
 
 /*
  * we use memory pools for preallocating messages we may receive, to
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index f88eacb..caaf03a 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -6,9 +6,9 @@
 #include <linux/mempool.h>
 #include <linux/rbtree.h>
 
-#include "types.h"
-#include "osdmap.h"
-#include "messenger.h"
+#include <linux/ceph/types.h>
+#include <linux/ceph/osdmap.h>
+#include <linux/ceph/messenger.h>
 
 struct ceph_msg;
 struct ceph_snap_context;
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index ba4c205..4ae6e27 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -2,8 +2,8 @@
 #define _FS_CEPH_OSDMAP_H
 
 #include <linux/rbtree.h>
-#include "types.h"
-#include "ceph_fs.h"
+#include <linux/ceph/types.h>
+#include <linux/ceph/ceph_fs.h>
 #include <linux/crush/crush.h>
 
 /*
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 0a99099..de91fbd 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -6,7 +6,7 @@
  * (Reliable Autonomic Distributed Object Store).
  */
 
-#include "msgr.h"
+#include <linux/ceph/msgr.h>
 
 /*
  * osdmap encoding versions
diff --git a/include/linux/ceph/types.h b/include/linux/ceph/types.h
index 28b35a0..d3ff1cf 100644
--- a/include/linux/ceph/types.h
+++ b/include/linux/ceph/types.h
@@ -7,9 +7,9 @@
 #include <linux/fcntl.h>
 #include <linux/string.h>
 
-#include "ceph_fs.h"
-#include "ceph_frag.h"
-#include "ceph_hash.h"
+#include <linux/ceph/ceph_fs.h>
+#include <linux/ceph/ceph_frag.h>
+#include <linux/ceph/ceph_hash.h>
 
 /*
  * Identify inodes by both their ino AND snapshot id (a u64).
diff --git a/include/linux/crush/mapper.h b/include/linux/crush/mapper.h
index c46b99c..bfe81a5 100644
--- a/include/linux/crush/mapper.h
+++ b/include/linux/crush/mapper.h
@@ -8,7 +8,7 @@
  * LGPL2
  */
 
-#include "crush.h"
+#include <linux/crush/crush.h>
 
 extern int crush_find_rule(struct crush_map *map, int pool, int type, int size);
 extern int crush_do_rule(struct crush_map *map,
diff --git a/include/linux/drbd_tag_magic.h b/include/linux/drbd_tag_magic.h
index 0695431..82de1f9 100644
--- a/include/linux/drbd_tag_magic.h
+++ b/include/linux/drbd_tag_magic.h
@@ -12,7 +12,7 @@ enum packet_types {
 #define NL_INT64(pn, pr, member)
 #define NL_BIT(pn, pr, member)
 #define NL_STRING(pn, pr, member, len)
-#include "drbd_nl.h"
+#include <linux/drbd_nl.h>
 	P_nl_after_last_packet,
 };
 
@@ -28,7 +28,7 @@ enum packet_types {
 #define NL_STRING(pn, pr, member, len)	\
 	unsigned char member[len]; int member ## _len; \
 	int tag_and_len ## member;
-#include "linux/drbd_nl.h"
+#include <linux/drbd_nl.h>
 
 /* declare tag-list-sizes */
 static const int tag_list_sizes[] = {
@@ -37,7 +37,7 @@ static const int tag_list_sizes[] = {
 #define NL_INT64(pn, pr, member)        + 4 + 8
 #define NL_BIT(pn, pr, member)          + 4 + 1
 #define NL_STRING(pn, pr, member, len)  + 4 + (len)
-#include "drbd_nl.h"
+#include <linux/drbd_nl.h>
 };
 
 /* The two highest bits are used for the tag type */
@@ -62,7 +62,7 @@ enum drbd_tags {
 #define NL_INT64(pn, pr, member)       T_ ## member = pn | TT_INT64   | pr ,
 #define NL_BIT(pn, pr, member)         T_ ## member = pn | TT_BIT     | pr ,
 #define NL_STRING(pn, pr, member, len) T_ ## member = pn | TT_STRING  | pr ,
-#include "drbd_nl.h"
+#include <linux/drbd_nl.h>
 };
 
 struct tag {
@@ -78,7 +78,7 @@ static const struct tag tag_descriptions[] = {
 #define NL_INT64(pn, pr, member)       [ pn ] = { #member, TT_INT64   | pr, sizeof(__u64) },
 #define NL_BIT(pn, pr, member)         [ pn ] = { #member, TT_BIT     | pr, sizeof(int)   },
 #define NL_STRING(pn, pr, member, len) [ pn ] = { #member, TT_STRING  | pr, (len)         },
-#include "drbd_nl.h"
+#include <linux/drbd_nl.h>
 };
 
 #endif
diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index 8dab596..3176a27 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -40,7 +40,7 @@
 /*****************************************************************************
  * H.323 Types
  ****************************************************************************/
-#include "nf_conntrack_h323_types.h"
+#include <linux/netfilter/nf_conntrack_h323_types.h>
 
 typedef struct {
 	enum {
diff --git a/include/scsi/osd_attributes.h b/include/scsi/osd_attributes.h
index 56e920a..303ba11 100644
--- a/include/scsi/osd_attributes.h
+++ b/include/scsi/osd_attributes.h
@@ -1,7 +1,7 @@
 #ifndef __OSD_ATTRIBUTES_H__
 #define __OSD_ATTRIBUTES_H__
 
-#include "osd_protocol.h"
+#include <scsi/osd_protocol.h>
 
 /*
  * Contains types and constants that define attribute pages and attribute
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 572fb54..b2e85fd 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -14,8 +14,8 @@
 #ifndef __OSD_INITIATOR_H__
 #define __OSD_INITIATOR_H__
 
-#include "osd_protocol.h"
-#include "osd_types.h"
+#include <scsi/osd_protocol.h>
+#include <scsi/osd_types.h>
 
 #include <linux/blkdev.h>
 #include <scsi/scsi_device.h>
diff --git a/include/scsi/osd_sec.h b/include/scsi/osd_sec.h
index 4c09fee..f96151c 100644
--- a/include/scsi/osd_sec.h
+++ b/include/scsi/osd_sec.h
@@ -14,8 +14,8 @@
 #ifndef __OSD_SEC_H__
 #define __OSD_SEC_H__
 
-#include "osd_protocol.h"
-#include "osd_types.h"
+#include <scsi/osd_protocol.h>
+#include <scsi/osd_types.h>
 
 /*
  * Contains types and constants of osd capabilities and security
diff --git a/include/sound/ac97_codec.h b/include/sound/ac97_codec.h
index 02cbb50..fdeb8dc 100644
--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -28,9 +28,9 @@
 #include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
-#include "pcm.h"
-#include "control.h"
-#include "info.h"
+#include <sound/pcm.h>
+#include <sound/control.h>
+#include <sound/info.h>
 
 /* maximum number of devices on the AC97 bus */
 #define	AC97_BUS_MAX_DEVICES	4
diff --git a/include/sound/ad1816a.h b/include/sound/ad1816a.h
index d010858..a7d8dc7 100644
--- a/include/sound/ad1816a.h
+++ b/include/sound/ad1816a.h
@@ -20,9 +20,9 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 */
 
-#include "control.h"
-#include "pcm.h"
-#include "timer.h"
+#include <sound/control.h>
+#include <sound/pcm.h>
+#include <sound/timer.h>
 
 #define AD1816A_REG(r)			(chip->port + r)
 
diff --git a/include/sound/ak4531_codec.h b/include/sound/ak4531_codec.h
index 575296c..85ea86e 100644
--- a/include/sound/ak4531_codec.h
+++ b/include/sound/ak4531_codec.h
@@ -25,8 +25,8 @@
  *
  */
 
-#include "info.h"
-#include "control.h"
+#include <sound/info.h>
+#include <sound/control.h>
 
 /*
  *  ASAHI KASEI - AK4531 codec
diff --git a/include/sound/cs46xx.h b/include/sound/cs46xx.h
index e3005a6..bc246a1 100644
--- a/include/sound/cs46xx.h
+++ b/include/sound/cs46xx.h
@@ -23,11 +23,11 @@
  *
  */
 
-#include "pcm.h"
-#include "pcm-indirect.h"
-#include "rawmidi.h"
-#include "ac97_codec.h"
-#include "cs46xx_dsp_spos.h"
+#include <sound/pcm.h>
+#include <sound/pcm-indirect.h>
+#include <sound/rawmidi.h>
+#include <sound/ac97_codec.h>
+#include <sound/cs46xx_dsp_spos.h>
 
 /*
  *  Direct registers
diff --git a/include/sound/cs46xx_dsp_spos.h b/include/sound/cs46xx_dsp_spos.h
index 8008c59..b4ed2b4 100644
--- a/include/sound/cs46xx_dsp_spos.h
+++ b/include/sound/cs46xx_dsp_spos.h
@@ -22,8 +22,8 @@
 #ifndef __CS46XX_DSP_SPOS_H__
 #define __CS46XX_DSP_SPOS_H__
 
-#include "cs46xx_dsp_scb_types.h"
-#include "cs46xx_dsp_task_types.h"
+#include <sound/cs46xx_dsp_scb_types.h>
+#include <sound/cs46xx_dsp_task_types.h>
 
 #define SYMBOL_CONSTANT  0x0
 #define SYMBOL_SAMPLE    0x1
diff --git a/include/sound/cs46xx_dsp_task_types.h b/include/sound/cs46xx_dsp_task_types.h
index 5cf920b..27df60e 100644
--- a/include/sound/cs46xx_dsp_task_types.h
+++ b/include/sound/cs46xx_dsp_task_types.h
@@ -27,7 +27,7 @@
 #ifndef __CS46XX_DSP_TASK_TYPES_H__
 #define __CS46XX_DSP_TASK_TYPES_H__
 
-#include "cs46xx_dsp_scb_types.h"
+#include <sound/cs46xx_dsp_scb_types.h>
 
 /*********************************************************************************************
 Example hierarchy of stream control blocks in the SP
diff --git a/include/sound/emu10k1_synth.h b/include/sound/emu10k1_synth.h
index 6ef61c4..9f211e9 100644
--- a/include/sound/emu10k1_synth.h
+++ b/include/sound/emu10k1_synth.h
@@ -20,8 +20,8 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "emu10k1.h"
-#include "emux_synth.h"
+#include <sound/emu10k1.h>
+#include <sound/emux_synth.h>
 
 /* sequencer device id */
 #define SNDRV_SEQ_DEV_ID_EMU10K1_SYNTH	"emu10k1-synth"
diff --git a/include/sound/emu8000.h b/include/sound/emu8000.h
index c8f66bd..c321302 100644
--- a/include/sound/emu8000.h
+++ b/include/sound/emu8000.h
@@ -21,8 +21,8 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "emux_synth.h"
-#include "seq_kernel.h"
+#include <sound/emux_synth.h>
+#include <sound/seq_kernel.h>
 
 /*
  * Hardware parameters.
diff --git a/include/sound/emux_legacy.h b/include/sound/emux_legacy.h
index 6fe3da2..baf43fc 100644
--- a/include/sound/emux_legacy.h
+++ b/include/sound/emux_legacy.h
@@ -22,7 +22,7 @@
  *
  */
 
-#include "seq_oss_legacy.h"
+#include <sound/seq_oss_legacy.h>
 
 /*
  * awe hardware controls
diff --git a/include/sound/emux_synth.h b/include/sound/emux_synth.h
index d8cb51b..fb81f37 100644
--- a/include/sound/emux_synth.h
+++ b/include/sound/emux_synth.h
@@ -21,15 +21,15 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "seq_kernel.h"
-#include "seq_device.h"
-#include "soundfont.h"
-#include "seq_midi_emul.h"
+#include <sound/seq_kernel.h>
+#include <sound/seq_device.h>
+#include <sound/soundfont.h>
+#include <sound/seq_midi_emul.h>
 #ifdef CONFIG_SND_SEQUENCER_OSS
-#include "seq_oss.h"
+#include <sound/seq_oss.h>
 #endif
-#include "emux_legacy.h"
-#include "seq_virmidi.h"
+#include <sound/emux_legacy.h>
+#include <sound/seq_virmidi.h>
 
 /*
  * compile flags
diff --git a/include/sound/es1688.h b/include/sound/es1688.h
index 3ec7ecb..7bd4243 100644
--- a/include/sound/es1688.h
+++ b/include/sound/es1688.h
@@ -22,8 +22,8 @@
  *
  */
 
-#include "control.h"
-#include "pcm.h"
+#include <sound/control.h>
+#include <sound/pcm.h>
 #include <linux/interrupt.h>
 
 #define ES1688_HW_AUTO		0x0000
diff --git a/include/sound/gus.h b/include/sound/gus.h
index 841bb8d..42905d8 100644
--- a/include/sound/gus.h
+++ b/include/sound/gus.h
@@ -22,11 +22,11 @@
  *
  */
 
-#include "pcm.h"
-#include "rawmidi.h"
-#include "timer.h"
-#include "seq_midi_emul.h"
-#include "seq_device.h"
+#include <sound/pcm.h>
+#include <sound/rawmidi.h>
+#include <sound/timer.h>
+#include <sound/seq_midi_emul.h>
+#include <sound/seq_device.h>
 #include <asm/io.h>
 
 /* IO ports */
diff --git a/include/sound/mpu401.h b/include/sound/mpu401.h
index 1f1d53f..a85ce16 100644
--- a/include/sound/mpu401.h
+++ b/include/sound/mpu401.h
@@ -22,7 +22,7 @@
  *
  */
 
-#include "rawmidi.h"
+#include <sound/rawmidi.h>
 #include <linux/interrupt.h>
 
 #define MPU401_HW_MPU401		1	/* native MPU401 */
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 57e71fa..3d96d3d 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -35,7 +35,7 @@
 #define snd_pcm_chip(pcm) ((pcm)->private_data)
 
 #if defined(CONFIG_SND_PCM_OSS) || defined(CONFIG_SND_PCM_OSS_MODULE)
-#include "pcm_oss.h"
+#include <sound/pcm_oss.h>
 #endif
 
 /*
diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index 6b14359..adf0885 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -30,7 +30,7 @@
 #include <linux/workqueue.h>
 
 #if defined(CONFIG_SND_SEQUENCER) || defined(CONFIG_SND_SEQUENCER_MODULE)
-#include "seq_device.h"
+#include <sound/seq_device.h>
 #endif
 
 /*
diff --git a/include/sound/sb.h b/include/sound/sb.h
index 9535354..ba39603 100644
--- a/include/sound/sb.h
+++ b/include/sound/sb.h
@@ -22,8 +22,8 @@
  *
  */
 
-#include "pcm.h"
-#include "rawmidi.h"
+#include <sound/pcm.h>
+#include <sound/rawmidi.h>
 #include <linux/interrupt.h>
 #include <asm/io.h>
 
diff --git a/include/sound/sb16_csp.h b/include/sound/sb16_csp.h
index af1b49e..7e95056 100644
--- a/include/sound/sb16_csp.h
+++ b/include/sound/sb16_csp.h
@@ -119,8 +119,8 @@ struct snd_sb_csp_info {
 #define SNDRV_SB_CSP_IOCTL_RESTART	_IO('H', 0x16)
 
 #ifdef __KERNEL__
-#include "sb.h"
-#include "hwdep.h"
+#include <sound/sb.h>
+#include <sound/hwdep.h>
 #include <linux/firmware.h>
 
 struct snd_sb_csp;
diff --git a/include/sound/seq_kernel.h b/include/sound/seq_kernel.h
index 3d9afb6..34fb34c 100644
--- a/include/sound/seq_kernel.h
+++ b/include/sound/seq_kernel.h
@@ -22,7 +22,7 @@
  *
  */
 #include <linux/time.h>
-#include "asequencer.h"
+#include <sound/asequencer.h>
 
 typedef struct snd_seq_real_time snd_seq_real_time_t;
 typedef union snd_seq_timestamp snd_seq_timestamp_t;
diff --git a/include/sound/seq_midi_emul.h b/include/sound/seq_midi_emul.h
index d6c4615..8139d8c 100644
--- a/include/sound/seq_midi_emul.h
+++ b/include/sound/seq_midi_emul.h
@@ -22,7 +22,7 @@
  *
  */
 
-#include "seq_kernel.h"
+#include <sound/seq_kernel.h>
 
 /*
  * This structure is used to keep track of the current state on each
diff --git a/include/sound/seq_midi_event.h b/include/sound/seq_midi_event.h
index 5efab8b..e40f43e 100644
--- a/include/sound/seq_midi_event.h
+++ b/include/sound/seq_midi_event.h
@@ -22,7 +22,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "asequencer.h"
+#include <sound/asequencer.h>
 
 #define MAX_MIDI_EVENT_BUF	256
 
diff --git a/include/sound/seq_oss.h b/include/sound/seq_oss.h
index 9b060bb..d0b27ec 100644
--- a/include/sound/seq_oss.h
+++ b/include/sound/seq_oss.h
@@ -21,8 +21,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "asequencer.h"
-#include "seq_kernel.h"
+#include <sound/asequencer.h>
+#include <sound/seq_kernel.h>
 
 /*
  * argument structure for synthesizer operations
diff --git a/include/sound/seq_virmidi.h b/include/sound/seq_virmidi.h
index d888433..a03acd0 100644
--- a/include/sound/seq_virmidi.h
+++ b/include/sound/seq_virmidi.h
@@ -22,8 +22,8 @@
  *
  */
 
-#include "rawmidi.h"
-#include "seq_midi_event.h"
+#include <sound/rawmidi.h>
+#include <sound/seq_midi_event.h>
 
 /*
  * device file instance:
diff --git a/include/sound/snd_wavefront.h b/include/sound/snd_wavefront.h
index fa149ca..35e94b3 100644
--- a/include/sound/snd_wavefront.h
+++ b/include/sound/snd_wavefront.h
@@ -1,10 +1,10 @@
 #ifndef __SOUND_SND_WAVEFRONT_H__
 #define __SOUND_SND_WAVEFRONT_H__
 
-#include "mpu401.h"
-#include "hwdep.h"
-#include "rawmidi.h"
-#include "wavefront.h"  /* generic OSS/ALSA/user-level wavefront header */
+#include <sound/mpu401.h>
+#include <sound/hwdep.h>
+#include <sound/rawmidi.h>
+#include <sound/wavefront.h>  /* generic OSS/ALSA/user-level wavefront header */
 
 /* MIDI interface */
 
diff --git a/include/sound/soundfont.h b/include/sound/soundfont.h
index 679df05..7c93efd 100644
--- a/include/sound/soundfont.h
+++ b/include/sound/soundfont.h
@@ -22,8 +22,8 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include "sfnt_info.h"
-#include "util_mem.h"
+#include <sound/sfnt_info.h>
+#include <sound/util_mem.h>
 
 #define SF_MAX_INSTRUMENTS	128	/* maximum instrument number */
 #define SF_MAX_PRESETS  256	/* drums are mapped from 128 to 256 */
diff --git a/include/sound/tea6330t.h b/include/sound/tea6330t.h
index 51b282b..e6beec2 100644
--- a/include/sound/tea6330t.h
+++ b/include/sound/tea6330t.h
@@ -22,7 +22,7 @@
  *
  */
 
-#include "i2c.h"		/* generic i2c support */
+#include <sound/i2c.h>		/* generic i2c support */
 
 int snd_tea6330t_detect(struct snd_i2c_bus *bus, int equalizer);
 int snd_tea6330t_update_mixer(struct snd_card *card, struct snd_i2c_bus *bus,
diff --git a/include/sound/trident.h b/include/sound/trident.h
index 9f191a0..9b3b03e 100644
--- a/include/sound/trident.h
+++ b/include/sound/trident.h
@@ -23,10 +23,10 @@
  *
  */
 
-#include "pcm.h"
-#include "mpu401.h"
-#include "ac97_codec.h"
-#include "util_mem.h"
+#include <sound/pcm.h>
+#include <sound/mpu401.h>
+#include <sound/ac97_codec.h>
+#include <sound/util_mem.h>
 
 #define TRIDENT_DEVICE_ID_DX		((PCI_VENDOR_ID_TRIDENT<<16)|PCI_DEVICE_ID_TRIDENT_4DWAVE_DX)
 #define TRIDENT_DEVICE_ID_NX		((PCI_VENDOR_ID_TRIDENT<<16)|PCI_DEVICE_ID_TRIDENT_4DWAVE_NX)
diff --git a/include/sound/wss.h b/include/sound/wss.h
index fd01f22..0c7f034 100644
--- a/include/sound/wss.h
+++ b/include/sound/wss.h
@@ -22,11 +22,11 @@
  *
  */
 
-#include "control.h"
-#include "pcm.h"
-#include "timer.h"
+#include <sound/control.h>
+#include <sound/pcm.h>
+#include <sound/timer.h>
 
-#include "cs4231-regs.h"
+#include <sound/cs4231-regs.h>
 
 /* defines for codec.mode */
 
diff --git a/include/sound/ymfpci.h b/include/sound/ymfpci.h
index 444cd6b..5db53b6 100644
--- a/include/sound/ymfpci.h
+++ b/include/sound/ymfpci.h
@@ -22,10 +22,10 @@
  *
  */
 
-#include "pcm.h"
-#include "rawmidi.h"
-#include "ac97_codec.h"
-#include "timer.h"
+#include <sound/pcm.h>
+#include <sound/rawmidi.h>
+#include <sound/ac97_codec.h>
+#include <sound/timer.h>
 #include <linux/gameport.h>
 
 /*
diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index 388bcdd..fde1b3e 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -6,7 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/tracepoint.h>
-#include "gfpflags.h"
+#include <trace/events/gfpflags.h>
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index a9c87ad..f0e1523 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -6,7 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/tracepoint.h>
-#include "gfpflags.h"
+#include <trace/events/gfpflags.h>
 
 DECLARE_EVENT_CLASS(kmem_alloc,
 
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 36851f7..026a298 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -8,7 +8,7 @@
 #include <linux/tracepoint.h>
 #include <linux/mm.h>
 #include <linux/memcontrol.h>
-#include "gfpflags.h"
+#include <trace/events/gfpflags.h>
 
 #define RECLAIM_WB_ANON		0x0001u
 #define RECLAIM_WB_FILE		0x0002u
diff --git a/include/xen/interface/callback.h b/include/xen/interface/callback.h
index 2ae3cd2..8c5fa0e 100644
--- a/include/xen/interface/callback.h
+++ b/include/xen/interface/callback.h
@@ -27,7 +27,7 @@
 #ifndef __XEN_PUBLIC_CALLBACK_H__
 #define __XEN_PUBLIC_CALLBACK_H__
 
-#include "xen.h"
+#include <xen/interface/xen.h>
 
 /*
  * Prototype for this hypercall is:
diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index 1888d8c..f5bc22b 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -21,7 +21,7 @@
 #ifndef __XEN_PUBLIC_HVM_PARAMS_H__
 #define __XEN_PUBLIC_HVM_PARAMS_H__
 
-#include "hvm_op.h"
+#include <xen/interface/hvm/hvm_op.h>
 
 /*
  * Parameter space for HVMOP_{set,get}_param.
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 3d5d6db..2165651 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -9,8 +9,8 @@
 #ifndef __XEN_PUBLIC_IO_BLKIF_H__
 #define __XEN_PUBLIC_IO_BLKIF_H__
 
-#include "ring.h"
-#include "../grant_table.h"
+#include <xen/interface/io/ring.h>
+#include <xen/interface/grant_table.h>
 
 /*
  * Front->back notifications: When enqueuing a new request, sending a
diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index cb94668..9dfc120 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -9,8 +9,8 @@
 #ifndef __XEN_PUBLIC_IO_NETIF_H__
 #define __XEN_PUBLIC_IO_NETIF_H__
 
-#include "ring.h"
-#include "../grant_table.h"
+#include <xen/interface/io/ring.h>
+#include <xen/interface/grant_table.h>
 
 /*
  * Notifications after enqueuing any type of message should be conditional on
diff --git a/include/xen/interface/sched.h b/include/xen/interface/sched.h
index dd55dac..9ce0839 100644
--- a/include/xen/interface/sched.h
+++ b/include/xen/interface/sched.h
@@ -9,7 +9,7 @@
 #ifndef __XEN_PUBLIC_SCHED_H__
 #define __XEN_PUBLIC_SCHED_H__
 
-#include "event_channel.h"
+#include <xen/interface/event_channel.h>
 
 /*
  * The prototype for this hypercall is:
diff --git a/include/xen/interface/version.h b/include/xen/interface/version.h
index e8b6519..ff372a5 100644
--- a/include/xen/interface/version.h
+++ b/include/xen/interface/version.h
@@ -55,7 +55,7 @@ struct xen_feature_info {
 };
 
 /* Declares the features reported by XENVER_get_features. */
-#include "features.h"
+#include <xen/interface/features.h>
 
 /* arg == NULL; returns host memory page size. */
 #define XENVER_pagesize 7

