Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1FTKuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:50:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1FTKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ro4BifX6igGUqeVe9hPCLbPCIVQPbltNG8WiAKMooweXbREQcVqyg7Kr3RyLh7Vojt
         Db5jcjZ7SCnYU26O7q0XIDfCguq9+h1Ie2LEnPscGK+kM7kJy+rY21MlanZo9zfvUJHZ
         cQ39b6T48Vx2uWbUQVaV+2uWcz93RvEAdKDoE=
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate
 linux/leds.h include
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@mvista.com>, vitalivanov@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
In-Reply-To: <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
	 <4DFF1AA5.80508@ru.mvista.com>
	 <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 13:49:24 +0300
Message-ID: <1308566964.13261.14.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giri,

I would still recommend to use the following patch as it corrects many other places for trivial includes duplication.
Also I was the first who sent it:).

Probably trivial is the correct list to send it to, so sorry for sending it to main list first.

--
From: Vitaliy Ivanov <vitalivanov@gmail.com>

Many stupid corrections of duplicated includes based on the output of scripts/checkincludes.pl.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

>From c2553ee8d64e52e1fb86fa95ffbaec5af1627077 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Wed, 15 Jun 2011 21:01:43 +0300
Subject: [PATCH] Headers duplication corrections based on checkincludes script output.

---
 arch/arm/mach-dove/common.c                        |    1 -
 arch/arm/mach-s3c2410/h1940-bluetooth.c            |    1 -
 arch/mips/lantiq/devices.c                         |    2 --
 arch/mips/lantiq/xway/devices.c                    |    2 --
 arch/powerpc/platforms/pseries/smp.c               |    1 -
 arch/s390/kvm/sie64a.S                             |    1 -
 arch/s390/oprofile/init.c                          |    2 --
 arch/x86/kvm/mmu.c                                 |    1 -
 arch/xtensa/include/asm/uaccess.h                  |    3 +--
 drivers/gpio/ab8500-gpio.c                         |    1 -
 drivers/gpu/drm/nouveau/nv50_graph.c               |    1 -
 drivers/media/rc/ite-cir.c                         |    1 -
 drivers/media/video/m5mols/m5mols_capture.c        |    1 -
 drivers/media/video/videobuf2-memops.c             |    1 -
 drivers/net/can/c_can/c_can.c                      |    1 -
 drivers/net/can/c_can/c_can_platform.c             |    1 -
 drivers/net/sungem.c                               |    3 +--
 drivers/net/wireless/ath/ath5k/ahb.c               |    1 -
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 -
 drivers/staging/bcm/headers.h                      |    7 ++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    9 ++-------
 drivers/staging/gma500/psb_2d.c                    |    1 -
 drivers/staging/hv/hv_mouse.c                      |    1 -
 drivers/staging/hv/tools/hv_kvp_daemon.c           |    1 -
 drivers/staging/nvec/nvec.c                        |    1 -
 drivers/staging/rtl8712/drv_types.h                |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    1 -
 drivers/staging/sep/sep_driver.c                   |    1 -
 drivers/staging/usbip/userspace/src/utils.h        |    1 -
 .../cyashalomap_kernel.h                           |    2 +-
 .../staging/westbridge/astoria/gadget/cyasgadget.h |    8 ++------
 drivers/target/loopback/tcm_loop.c                 |    1 -
 drivers/target/tcm_fc/tfc_cmd.c                    |    1 -
 drivers/target/tcm_fc/tfc_conf.c                   |    1 -
 drivers/target/tcm_fc/tfc_io.c                     |    1 -
 drivers/target/tcm_fc/tfc_sess.c                   |    2 --
 drivers/usb/otg/otg_fsm.c                          |    1 -
 drivers/video/udlfb.c                              |    1 -
 drivers/watchdog/intel_scu_watchdog.c              |    1 -
 fs/nfs/idmap.c                                     |    7 ++-----
 fs/ocfs2/move_extents.c                            |    1 -
 include/linux/fs.h                                 |    1 -
 net/ipv4/ping.c                                    |    1 -
 45 files changed, 11 insertions(+), 70 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 5ed51b8..b6c3d6b 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
-#include <linux/serial_8250.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
 #include <asm/setup.h>
diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index 2c126bb..a5eeb62 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -18,7 +18,6 @@
 #include <linux/leds.h>
 #include <linux/gpio.h>
 #include <linux/rfkill.h>
-#include <linux/leds.h>
 
 #include <mach/regs-gpio.h>
 #include <mach/hardware.h>
diff --git a/arch/mips/lantiq/devices.c b/arch/mips/lantiq/devices.c
index 7b82c34..44a3677 100644
--- a/arch/mips/lantiq/devices.c
+++ b/arch/mips/lantiq/devices.c
@@ -15,11 +15,9 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/etherdevice.h>
-#include <linux/reboot.h>
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
-#include <linux/leds.h>
 
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
diff --git a/arch/mips/lantiq/xway/devices.c b/arch/mips/lantiq/xway/devices.c
index e09e789..d0e32ab 100644
--- a/arch/mips/lantiq/xway/devices.c
+++ b/arch/mips/lantiq/xway/devices.c
@@ -16,11 +16,9 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/etherdevice.h>
-#include <linux/reboot.h>
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
-#include <linux/leds.h>
 
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index fbffd7e..cd70be5 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -44,7 +44,6 @@
 #include <asm/mpic.h>
 #include <asm/vdso_datapage.h>
 #include <asm/cputhreads.h>
-#include <asm/mpic.h>
 #include <asm/xics.h>
 
 #include "plpar_wrappers.h"
diff --git a/arch/s390/kvm/sie64a.S b/arch/s390/kvm/sie64a.S
index 5faa1b1..cf8ec3a 100644
--- a/arch/s390/kvm/sie64a.S
+++ b/arch/s390/kvm/sie64a.S
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
-#include <asm/asm-offsets.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 5995e9b..0c2d94b 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -13,8 +13,6 @@
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/oprofile.h>
-#include <linux/errno.h>
 #include <linux/fs.h>
 
 #include "../../../drivers/oprofile/oprof.h"
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bd14bb4..9b9f012 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -22,7 +22,6 @@
 #include "mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
-#include "x86.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index 5b0c18c..82d4e38 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -17,6 +17,7 @@
 #define _XTENSA_UACCESS_H
 
 #include <linux/errno.h>
+#include <asm/types.h>
 
 #define VERIFY_READ    0
 #define VERIFY_WRITE   1
@@ -26,7 +27,6 @@
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/processor.h>
-#include <asm/types.h>
 
 /*
  * These assembly macros mirror the C macros that follow below.  They
@@ -157,7 +157,6 @@
 #else /* __ASSEMBLY__ not defined */
 
 #include <linux/sched.h>
-#include <asm/types.h>
 
 /*
  * The fs value determines whether argument validity checking should
diff --git a/drivers/gpio/ab8500-gpio.c b/drivers/gpio/ab8500-gpio.c
index 970053c..ed795e6 100644
--- a/drivers/gpio/ab8500-gpio.c
+++ b/drivers/gpio/ab8500-gpio.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
-#include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff --git a/drivers/gpu/drm/nouveau/nv50_graph.c b/drivers/gpu/drm/nouveau/nv50_graph.c
index e25cbb4..40680f2 100644
--- a/drivers/gpu/drm/nouveau/nv50_graph.c
+++ b/drivers/gpu/drm/nouveau/nv50_graph.c
@@ -31,7 +31,6 @@
 #include "nouveau_grctx.h"
 #include "nouveau_dma.h"
 #include "nouveau_vm.h"
-#include "nouveau_ramht.h"
 #include "nv50_evo.h"
 
 struct nv50_graph_engine {
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index e716b93..cd0c44e 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -42,7 +42,6 @@
 #include <linux/bitops.h>
 #include <media/rc-core.h>
 #include <linux/pci_ids.h>
-#include <linux/delay.h>
 
 #include "ite-cir.h"
 
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index d71a390..e1ae565 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -22,7 +22,6 @@
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
-#include <linux/version.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 5370a3a..b03c3ae 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -18,7 +18,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/file.h>
-#include <linux/slab.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 7e5cc0b..ff21291 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -34,7 +34,6 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/list.h>
-#include <linux/delay.h>
 #include <linux/io.h>
 
 #include <linux/can.h>
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index cc90824..0b07156 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -28,7 +28,6 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/list.h>
-#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index ab59300..70f018d 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -66,15 +66,14 @@
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
+#include <asm/prom.h>
 
 #ifdef CONFIG_SPARC
 #include <asm/idprom.h>
-#include <asm/prom.h>
 #endif
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/pci-bridge.h>
-#include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index ea99827..45dd20c 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -24,7 +24,6 @@
 #include "debug.h"
 #include "base.h"
 #include "reg.h"
-#include "debug.h"
 
 /* return bus cachesize in 4B word units */
 static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 22453b0..11dc39c 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -52,7 +52,6 @@
 #include "aggr_recv_api.h"
 #include <host_version.h>
 #include <linux/rtnetlink.h>
-#include <linux/init.h>
 #include <linux/moduleparam.h>
 #include "ar6000_api.h"
 #ifdef CONFIG_HOST_TCMD_SUPPORT
diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index 1148e5e..8fe8d2b 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -20,25 +20,23 @@
 #include <linux/file.h>
 #include <linux/string.h>
 #include <linux/etherdevice.h>
-#include <net/ip.h>
 #include <linux/wait.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
-
 #include <linux/version.h>
 #include <linux/stddef.h>
-#include <linux/kernel.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/unistd.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
-#include <asm/uaccess.h>
 #include <linux/kthread.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/usb.h>
+#include <asm/uaccess.h>
+#include <net/ip.h>
 
 #include "Typedefs.h"
 #include "Version.h"
@@ -61,7 +59,6 @@
 #include "Queue.h"
 #include "vendorspecificextn.h"
 
-
 #include "InterfaceMacros.h"
 #include "InterfaceAdapter.h"
 #include "InterfaceIsr.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a71c6f8..8cbfeae 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -26,7 +26,6 @@
 #include BCMEMBEDIMAGE
 #endif				/* BCMEMBEDIMAGE */
 
-#include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmdevs.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 996033c..d4bcc1e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -18,7 +18,6 @@
 #define _wl_cfg80211_h_
 
 #include <linux/wireless.h>
-#include <linux/wireless.h>
 #include <net/cfg80211.h>
 #include <wlioctl.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 15e1b05..ab843bc 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -19,21 +19,16 @@
 #include <bcmdefs.h>
 #include <linux/netdevice.h>
 #include <wlioctl.h>
-
 #include <bcmutils.h>
-
 #include <linux/if_arp.h>
 #include <asm/uaccess.h>
+#include <linux/ieee80211.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhdioctl.h>
-#include <linux/ieee80211.h>
-typedef const struct si_pub si_t;
-#include <wlioctl.h>
 
-#include <dngl_stats.h>
-#include <dhd.h>
+typedef const struct si_pub si_t;
 
 #define WL_ERROR(fmt, args...)	printk(fmt, ##args)
 #define WL_TRACE(fmt, args...)	no_printk(fmt, ##args)
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 0bd834c..3aee8fc 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -38,7 +38,6 @@
 
 #include "psb_drv.h"
 #include "psb_reg.h"
-#include "psb_drv.h"
 #include "psb_fb.h"
 
 void psb_spank(struct drm_psb_private *dev_priv)
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 359e737..b3324d6 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -24,7 +24,6 @@
 #include <linux/hiddev.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
-#include <linux/delay.h>
 
 #include "hyperv.h"
 
diff --git a/drivers/staging/hv/tools/hv_kvp_daemon.c b/drivers/staging/hv/tools/hv_kvp_daemon.c
index 33f0f1c..a4a407f 100644
--- a/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ b/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -35,7 +35,6 @@
 #include <arpa/inet.h>
 #include <linux/connector.h>
 #include <linux/netlink.h>
-#include <sys/socket.h>
 #include <ifaddrs.h>
 #include <netdb.h>
 #include <syslog.h>
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 1a94364..72258e8 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -21,7 +21,6 @@
 #include <linux/semaphore.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
-#include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include "nvec.h"
 
diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 3bb66dc..4f380a6 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -29,7 +29,6 @@ struct	qos_priv	{
 
 #include "rtl871x_ht.h"
 #include "rtl871x_cmd.h"
-#include "wlan_bssdef.h"
 #include "rtl871x_xmit.h"
 #include "rtl871x_recv.h"
 #include "rtl871x_security.h"
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 3d3f73c..505395c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kref.h>
-#include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>
 #include <linux/usb/ch9.h>
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 52342c1..848b4c5 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -50,7 +50,6 @@
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <asm/cacheflush.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/rar_register.h>
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index 6c29ae9..991f662 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -13,7 +13,6 @@
 #include <glib.h>
 #include <unistd.h>
 #include <stdio.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <stdlib.h>
diff --git a/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h b/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
index 6426ea6..1e9212f 100644
--- a/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
+++ b/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
@@ -315,5 +315,5 @@ void cy_as_hal_set_ep_dma_mode(uint8_t ep, bool sg_xfer_enabled);
 /* moved to staging location
 #include <linux/westbridge/cyas_cplus_end.h>
 */
-#include "../../../../../../../include/linux/westbridge/cyas_cplus_start.h"
+#include "../../../../../../../include/linux/westbridge/cyas_cplus_end.h"
 #endif
diff --git a/drivers/staging/westbridge/astoria/gadget/cyasgadget.h b/drivers/staging/westbridge/astoria/gadget/cyasgadget.h
index e01cea7..668e03f 100644
--- a/drivers/staging/westbridge/astoria/gadget/cyasgadget.h
+++ b/drivers/staging/westbridge/astoria/gadget/cyasgadget.h
@@ -54,19 +54,15 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/init.h>
 
 #include "../include/linux/westbridge/cyastoria.h"
 #include "../include/linux/westbridge/cyashal.h"
 #include "../include/linux/westbridge/cyasdevice.h"
 #include "cyasgadget_ioctl.h"
 
-#include <linux/module.h>
-#include <linux/init.h>
-
 /*char driver defines, revisit*/
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
 #include <linux/types.h>	/* size_t */
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index dee2a2c..ee95903 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,7 +31,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index c056a11..7c22062 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -45,7 +45,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/target_core_tmr.h>
 #include <target/configfs_macros.h>
 
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 84e868c..d963d90 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -48,7 +48,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
 #include "tcm_fc.h"
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 4c3c0ef..b4433be 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -53,7 +53,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
 #include "tcm_fc.h"
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index a3bd57f..65d8ea0 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -46,10 +46,8 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
-#include <scsi/libfc.h>
 #include "tcm_fc.h"
 
 static void ft_sess_delete_all(struct ft_tport *);
diff --git a/drivers/usb/otg/otg_fsm.c b/drivers/usb/otg/otg_fsm.c
index b0cc422..0911738 100644
--- a/drivers/usb/otg/otg_fsm.c
+++ b/drivers/usb/otg/otg_fsm.c
@@ -28,7 +28,6 @@
 #include <linux/usb.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
-#include <linux/types.h>
 
 #include "otg_fsm.h"
 
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 52b0f3e..14b152a 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/prefetch.h>
 #include <linux/delay.h>
-#include <linux/prefetch.h>
 #include <video/udlfb.h>
 #include "edid.h"
 
diff --git a/drivers/watchdog/intel_scu_watchdog.c b/drivers/watchdog/intel_scu_watchdog.c
index 919bdd1..ba43860 100644
--- a/drivers/watchdog/intel_scu_watchdog.c
+++ b/drivers/watchdog/intel_scu_watchdog.c
@@ -42,7 +42,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/sfi.h>
-#include <linux/types.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/intel_scu_ipc.h>
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 79664a1..f20801a 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -36,6 +36,8 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/nfs_idmap.h>
 
 static int nfs_map_string_to_numeric(const char *name, size_t namelen, __u32 *res)
 {
@@ -59,12 +61,10 @@ static int nfs_map_numeric_to_string(__u32 id, char *buf, size_t buflen)
 
 #ifdef CONFIG_NFS_USE_NEW_IDMAPPER
 
-#include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/sunrpc/sched.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_fs_sb.h>
-#include <linux/nfs_idmap.h>
 #include <linux/keyctl.h>
 #include <linux/key-type.h>
 #include <linux/rcupdate.h>
@@ -284,18 +284,15 @@ int nfs_map_gid_to_group(const struct nfs_server *server, __u32 gid, char *buf,
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
-#include <linux/slab.h>
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/sched.h>
-
 #include <linux/sunrpc/clnt.h>
 #include <linux/workqueue.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
 
 #include <linux/nfs_fs.h>
 
-#include <linux/nfs_idmap.h>
 #include "nfs4_fs.h"
 
 #define IDMAP_HASH_SZ          128
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index cd94270..d53cb70 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -36,7 +36,6 @@
 #include "dir.h"
 #include "buffer_head_io.h"
 #include "sysfile.h"
-#include "suballoc.h"
 #include "refcounttree.h"
 #include "move_extents.h"
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1c77787..450ca24 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -376,7 +376,6 @@ struct inodes_stat_t {
 
 #include <linux/linkage.h>
 #include <linux/wait.h>
-#include <linux/types.h>
 #include <linux/kdev_t.h>
 #include <linux/dcache.h>
 #include <linux/path.h>
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 9aaa671..39b403f 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -41,7 +41,6 @@
 #include <linux/proc_fs.h>
 #include <net/sock.h>
 #include <net/ping.h>
-#include <net/icmp.h>
 #include <net/udp.h>
 #include <net/route.h>
 #include <net/inet_common.h>
-- 
1.7.0.4



On Mon, 2011-06-20 at 12:34 +0200, Jesper Juhl wrote:
> On Mon, 20 Jun 2011, Sergei Shtylyov wrote:
> 
> > Hello.
> > 
> > On 20-06-2011 12:40, Jesper Juhl wrote:
> > 
> > > Remove the duplicate inclusion of linux/leds.h from
> > > arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.
> > 
> >    Pelase also specify that commit's summary in parens.
> > 
> 
> Anyone can just do a "git show 50e2d10d" to read it. But sure, here's a 
> new patch description:
> 
> Remove the duplicate inclusion of linux/leds.h from 
> arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d 
> (ARM: S3C2410: H1940: Use leds-gpio driver for LEDs managing).
> 
> 
> > > Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> > 
> > WBR, Sergei
> > 
> 


