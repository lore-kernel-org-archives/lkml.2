Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0L3EC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:02:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0L3ECp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EIfERwI/yTj6WO28QCBS1bZTYdl33C28rC5LXBzKkf+b34S/F4vruCNFWucjuJEb/J
         3iYm3xNPHmGTFhE+t6qQ==
Date: Wed, 29 Dec 2010 20:02:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/8] arch: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012291959580.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the
arch/ directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/arm/configs/am200epdkit_defconfig            |    2 +-
 arch/arm/configs/ams_delta_defconfig              |    2 +-
 arch/arm/configs/at572d940hfek_defconfig          |    2 +-
 arch/arm/configs/badge4_defconfig                 |    2 +-
 arch/arm/configs/bcmring_defconfig                |    2 +-
 arch/arm/configs/cm_x2xx_defconfig                |    2 +-
 arch/arm/configs/colibri_pxa270_defconfig         |    2 +-
 arch/arm/configs/collie_defconfig                 |    2 +-
 arch/arm/configs/corgi_defconfig                  |    2 +-
 arch/arm/configs/da8xx_omapl_defconfig            |    2 +-
 arch/arm/configs/davinci_all_defconfig            |    2 +-
 arch/arm/configs/dove_defconfig                   |    2 +-
 arch/arm/configs/ebsa110_defconfig                |    2 +-
 arch/arm/configs/edb7211_defconfig                |    2 +-
 arch/arm/configs/em_x270_defconfig                |    2 +-
 arch/arm/configs/ep93xx_defconfig                 |    2 +-
 arch/arm/configs/eseries_pxa_defconfig            |    2 +-
 arch/arm/configs/ezx_defconfig                    |    2 +-
 arch/arm/configs/footbridge_defconfig             |    2 +-
 arch/arm/configs/fortunet_defconfig               |    2 +-
 arch/arm/configs/h5000_defconfig                  |    2 +-
 arch/arm/configs/imote2_defconfig                 |    2 +-
 arch/arm/configs/ixp2000_defconfig                |    2 +-
 arch/arm/configs/ixp23xx_defconfig                |    2 +-
 arch/arm/configs/ixp4xx_defconfig                 |    2 +-
 arch/arm/configs/loki_defconfig                   |    2 +-
 arch/arm/configs/lpd7a400_defconfig               |    2 +-
 arch/arm/configs/lpd7a404_defconfig               |    2 +-
 arch/arm/configs/magician_defconfig               |    2 +-
 arch/arm/configs/mv78xx0_defconfig                |    2 +-
 arch/arm/configs/mx1_defconfig                    |    2 +-
 arch/arm/configs/mx21_defconfig                   |    2 +-
 arch/arm/configs/mx27_defconfig                   |    2 +-
 arch/arm/configs/mx3_defconfig                    |    2 +-
 arch/arm/configs/mx51_defconfig                   |    2 +-
 arch/arm/configs/nhk8815_defconfig                |    2 +-
 arch/arm/configs/omap2plus_defconfig              |    2 +-
 arch/arm/configs/orion5x_defconfig                |    2 +-
 arch/arm/configs/pcm027_defconfig                 |    2 +-
 arch/arm/configs/pcontrol_g20_defconfig           |    2 +-
 arch/arm/configs/pleb_defconfig                   |    2 +-
 arch/arm/configs/pnx4008_defconfig                |    2 +-
 arch/arm/configs/simpad_defconfig                 |    2 +-
 arch/arm/configs/spitz_defconfig                  |    2 +-
 arch/arm/configs/stmp378x_defconfig               |    2 +-
 arch/arm/configs/stmp37xx_defconfig               |    2 +-
 arch/arm/configs/sx1_defconfig                    |    2 +-
 arch/arm/configs/tct_hammer_defconfig             |    2 +-
 arch/arm/configs/trizeps4_defconfig               |    2 +-
 arch/arm/configs/u300_defconfig                   |    2 +-
 arch/arm/configs/viper_defconfig                  |    2 +-
 arch/arm/configs/xcep_defconfig                   |    2 +-
 arch/avr32/Kconfig                                |    4 ++--
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig        |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    2 +-
 arch/blackfin/configs/H8606_defconfig             |    2 +-
 arch/blackfin/configs/IP0X_defconfig              |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/configs/SRV1_defconfig              |    2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |    2 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +-
 arch/cris/configs/artpec_3_defconfig              |    2 +-
 arch/cris/configs/etrax-100lx_v2_defconfig        |    2 +-
 arch/cris/configs/etraxfs_defconfig               |    2 +-
 arch/frv/defconfig                                |    2 +-
 arch/h8300/defconfig                              |    2 +-
 arch/m32r/configs/m32700ut.smp_defconfig          |    2 +-
 arch/m32r/configs/m32700ut.up_defconfig           |    2 +-
 arch/m32r/configs/mappi.nommu_defconfig           |    2 +-
 arch/m32r/configs/mappi.smp_defconfig             |    2 +-
 arch/m32r/configs/mappi.up_defconfig              |    2 +-
 arch/m32r/configs/mappi2.opsp_defconfig           |    2 +-
 arch/m32r/configs/mappi2.vdec2_defconfig          |    2 +-
 arch/m32r/configs/mappi3.smp_defconfig            |    2 +-
 arch/m32r/configs/oaks32r_defconfig               |    2 +-
 arch/m32r/configs/opsput_defconfig                |    2 +-
 arch/m32r/configs/usrv_defconfig                  |    2 +-
 arch/m68knommu/configs/m5208evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5249evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5272c3_defconfig          |    2 +-
 arch/m68knommu/configs/m5275evb_defconfig         |    2 +-
 arch/m68knommu/configs/m5307c3_defconfig          |    2 +-
 arch/m68knommu/configs/m5407c3_defconfig          |    2 +-
 arch/m68knommu/defconfig                          |    2 +-
 arch/microblaze/configs/mmu_defconfig             |    2 +-
 arch/microblaze/configs/nommu_defconfig           |    2 +-
 arch/mips/Kconfig.debug                           |    2 +-
 arch/mips/configs/ar7_defconfig                   |    2 +-
 arch/mips/configs/bcm47xx_defconfig               |    2 +-
 arch/mips/configs/bcm63xx_defconfig               |    2 +-
 arch/mips/configs/bigsur_defconfig                |    2 +-
 arch/mips/configs/capcella_defconfig              |    2 +-
 arch/mips/configs/cavium-octeon_defconfig         |    2 +-
 arch/mips/configs/cobalt_defconfig                |    2 +-
 arch/mips/configs/db1000_defconfig                |    2 +-
 arch/mips/configs/db1100_defconfig                |    2 +-
 arch/mips/configs/db1200_defconfig                |    2 +-
 arch/mips/configs/db1500_defconfig                |    2 +-
 arch/mips/configs/db1550_defconfig                |    2 +-
 arch/mips/configs/decstation_defconfig            |    2 +-
 arch/mips/configs/e55_defconfig                   |    2 +-
 arch/mips/configs/fuloong2e_defconfig             |    2 +-
 arch/mips/configs/gpr_defconfig                   |    2 +-
 arch/mips/configs/ip22_defconfig                  |    2 +-
 arch/mips/configs/ip27_defconfig                  |    2 +-
 arch/mips/configs/ip28_defconfig                  |    2 +-
 arch/mips/configs/ip32_defconfig                  |    2 +-
 arch/mips/configs/jazz_defconfig                  |    2 +-
 arch/mips/configs/jmr3927_defconfig               |    2 +-
 arch/mips/configs/lasat_defconfig                 |    2 +-
 arch/mips/configs/lemote2f_defconfig              |    2 +-
 arch/mips/configs/malta_defconfig                 |    2 +-
 arch/mips/configs/markeins_defconfig              |    2 +-
 arch/mips/configs/mipssim_defconfig               |    2 +-
 arch/mips/configs/mpc30x_defconfig                |    2 +-
 arch/mips/configs/msp71xx_defconfig               |    2 +-
 arch/mips/configs/mtx1_defconfig                  |    2 +-
 arch/mips/configs/pb1100_defconfig                |    2 +-
 arch/mips/configs/pb1200_defconfig                |    2 +-
 arch/mips/configs/pb1500_defconfig                |    2 +-
 arch/mips/configs/pb1550_defconfig                |    2 +-
 arch/mips/configs/pnx8335-stb225_defconfig        |    2 +-
 arch/mips/configs/pnx8550-jbs_defconfig           |    2 +-
 arch/mips/configs/pnx8550-stb810_defconfig        |    2 +-
 arch/mips/configs/powertv_defconfig               |    2 +-
 arch/mips/configs/rb532_defconfig                 |    2 +-
 arch/mips/configs/rbtx49xx_defconfig              |    2 +-
 arch/mips/configs/rm200_defconfig                 |    2 +-
 arch/mips/configs/sb1250-swarm_defconfig          |    2 +-
 arch/mips/configs/tb0219_defconfig                |    2 +-
 arch/mips/configs/tb0226_defconfig                |    2 +-
 arch/mips/configs/tb0287_defconfig                |    2 +-
 arch/mips/configs/workpad_defconfig               |    2 +-
 arch/mips/configs/wrppmc_defconfig                |    2 +-
 arch/mips/configs/yosemite_defconfig              |    2 +-
 arch/mn10300/configs/asb2303_defconfig            |    2 +-
 arch/mn10300/configs/asb2364_defconfig            |    2 +-
 arch/parisc/configs/a500_defconfig                |    2 +-
 arch/parisc/configs/c3000_defconfig               |    2 +-
 arch/powerpc/configs/40x/acadia_defconfig         |    2 +-
 arch/powerpc/configs/40x/ep405_defconfig          |    2 +-
 arch/powerpc/configs/40x/hcu4_defconfig           |    2 +-
 arch/powerpc/configs/40x/kilauea_defconfig        |    2 +-
 arch/powerpc/configs/40x/makalu_defconfig         |    2 +-
 arch/powerpc/configs/40x/walnut_defconfig         |    2 +-
 arch/powerpc/configs/44x/arches_defconfig         |    2 +-
 arch/powerpc/configs/44x/bamboo_defconfig         |    2 +-
 arch/powerpc/configs/44x/bluestone_defconfig      |    2 +-
 arch/powerpc/configs/44x/canyonlands_defconfig    |    2 +-
 arch/powerpc/configs/44x/ebony_defconfig          |    2 +-
 arch/powerpc/configs/44x/eiger_defconfig          |    2 +-
 arch/powerpc/configs/44x/icon_defconfig           |    2 +-
 arch/powerpc/configs/44x/iss476-smp_defconfig     |    2 +-
 arch/powerpc/configs/44x/katmai_defconfig         |    2 +-
 arch/powerpc/configs/44x/rainier_defconfig        |    2 +-
 arch/powerpc/configs/44x/redwood_defconfig        |    2 +-
 arch/powerpc/configs/44x/sam440ep_defconfig       |    2 +-
 arch/powerpc/configs/44x/sequoia_defconfig        |    2 +-
 arch/powerpc/configs/44x/taishan_defconfig        |    2 +-
 arch/powerpc/configs/44x/warp_defconfig           |    2 +-
 arch/powerpc/configs/52xx/cm5200_defconfig        |    2 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig     |    2 +-
 arch/powerpc/configs/52xx/motionpro_defconfig     |    2 +-
 arch/powerpc/configs/52xx/pcm030_defconfig        |    2 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig       |    2 +-
 arch/powerpc/configs/83xx/asp8347_defconfig       |    2 +-
 arch/powerpc/configs/83xx/kmeter1_defconfig       |    2 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |    2 +-
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |    2 +-
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |    2 +-
 arch/powerpc/configs/83xx/sbc834x_defconfig       |    2 +-
 arch/powerpc/configs/85xx/ksi8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |    2 +-
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |    2 +-
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |    2 +-
 arch/powerpc/configs/85xx/sbc8548_defconfig       |    2 +-
 arch/powerpc/configs/85xx/sbc8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/socrates_defconfig      |    2 +-
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8540_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8541_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8548_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8555_defconfig       |    2 +-
 arch/powerpc/configs/85xx/tqm8560_defconfig       |    2 +-
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |    2 +-
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |    2 +-
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |    2 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |    2 +-
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |    2 +-
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |    2 +-
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |    2 +-
 arch/powerpc/configs/adder875_defconfig           |    2 +-
 arch/powerpc/configs/e55xx_smp_defconfig          |    2 +-
 arch/powerpc/configs/ep8248e_defconfig            |    2 +-
 arch/powerpc/configs/ep88xc_defconfig             |    2 +-
 arch/powerpc/configs/gamecube_defconfig           |    2 +-
 arch/powerpc/configs/holly_defconfig              |    2 +-
 arch/powerpc/configs/mgcoge_defconfig             |    2 +-
 arch/powerpc/configs/mgsuvd_defconfig             |    2 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |    2 +-
 arch/powerpc/configs/mpc8272_ads_defconfig        |    2 +-
 arch/powerpc/configs/mpc83xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc85xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig        |    2 +-
 arch/powerpc/configs/mpc866_ads_defconfig         |    2 +-
 arch/powerpc/configs/mpc86xx_defconfig            |    2 +-
 arch/powerpc/configs/mpc885_ads_defconfig         |    2 +-
 arch/powerpc/configs/ppc40x_defconfig             |    2 +-
 arch/powerpc/configs/ppc44x_defconfig             |    2 +-
 arch/powerpc/configs/pq2fads_defconfig            |    2 +-
 arch/powerpc/configs/ps3_defconfig                |    2 +-
 arch/powerpc/configs/storcenter_defconfig         |    2 +-
 arch/powerpc/configs/tqm8xx_defconfig             |    2 +-
 arch/powerpc/configs/wii_defconfig                |    2 +-
 arch/powerpc/platforms/iseries/Kconfig            |    2 +-
 arch/powerpc/platforms/pseries/Kconfig            |    6 +++---
 arch/score/configs/spct6600_defconfig             |    2 +-
 arch/sh/Kconfig                                   |    2 +-
 arch/tile/Kconfig                                 |    2 +-
 arch/tile/Kconfig.debug                           |    2 +-
 arch/tile/configs/tile_defconfig                  |    2 +-
 arch/um/defconfig                                 |    2 +-
 arch/x86/Kconfig                                  |   16 ++++++++--------
 arch/x86/Kconfig.cpu                              |    2 +-
 arch/x86/Kconfig.debug                            |    4 ++--
 arch/xtensa/configs/common_defconfig              |    2 +-
 arch/xtensa/configs/iss_defconfig                 |    2 +-
 arch/xtensa/configs/s6105_defconfig               |    2 +-
 254 files changed, 265 insertions(+), 265 deletions(-)

diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -3,7 +3,7 @@ CONFIG_LOCALVERSION="gum"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_EPOLL is not set
 # CONFIG_SHMEM is not set
diff --git a/arch/arm/configs/ams_delta_defconfig b/arch/arm/configs/ams_delta_defconfig
--- a/arch/arm/configs/ams_delta_defconfig
+++ b/arch/arm/configs/ams_delta_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/at572d940hfek_defconfig b/arch/arm/configs/at572d940hfek_defconfig
--- a/arch/arm/configs/at572d940hfek_defconfig
+++ b/arch/arm/configs/at572d940hfek_defconfig
@@ -17,7 +17,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -1,6 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 CONFIG_ARCH_SA1100=y
diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BASE_FULL is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLOB=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
--- a/arch/arm/configs/ebsa110_defconfig
+++ b/arch/arm/configs/ebsa110_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_ARCH_EBSA110=y
 CONFIG_PCCARD=m
diff --git a/arch/arm/configs/edb7211_defconfig b/arch/arm/configs/edb7211_defconfig
--- a/arch/arm/configs/edb7211_defconfig
+++ b/arch/arm/configs/edb7211_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_EDB7211=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -7,7 +7,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/footbridge_defconfig b/arch/arm/configs/footbridge_defconfig
--- a/arch/arm/configs/footbridge_defconfig
+++ b/arch/arm/configs/footbridge_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MODULES=y
 CONFIG_ARCH_FOOTBRIDGE=y
diff --git a/arch/arm/configs/fortunet_defconfig b/arch/arm/configs/fortunet_defconfig
--- a/arch/arm/configs/fortunet_defconfig
+++ b/arch/arm/configs/fortunet_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_ARCH_CLPS711X=y
 CONFIG_ARCH_FORTUNET=y
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/imote2_defconfig b/arch/arm/configs/imote2_defconfig
--- a/arch/arm/configs/imote2_defconfig
+++ b/arch/arm/configs/imote2_defconfig
@@ -6,7 +6,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/ixp2000_defconfig b/arch/arm/configs/ixp2000_defconfig
--- a/arch/arm/configs/ixp2000_defconfig
+++ b/arch/arm/configs/ixp2000_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/ixp23xx_defconfig b/arch/arm/configs/ixp23xx_defconfig
--- a/arch/arm/configs/ixp23xx_defconfig
+++ b/arch/arm/configs/ixp23xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/arm/configs/loki_defconfig b/arch/arm/configs/loki_defconfig
--- a/arch/arm/configs/loki_defconfig
+++ b/arch/arm/configs/loki_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/lpd7a400_defconfig b/arch/arm/configs/lpd7a400_defconfig
--- a/arch/arm/configs/lpd7a400_defconfig
+++ b/arch/arm/configs/lpd7a400_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 # CONFIG_IOSCHED_DEADLINE is not set
diff --git a/arch/arm/configs/lpd7a404_defconfig b/arch/arm/configs/lpd7a404_defconfig
--- a/arch/arm/configs/lpd7a404_defconfig
+++ b/arch/arm/configs/lpd7a404_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=16
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
diff --git a/arch/arm/configs/mx1_defconfig b/arch/arm/configs/mx1_defconfig
--- a/arch/arm/configs/mx1_defconfig
+++ b/arch/arm/configs/mx1_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/mx21_defconfig b/arch/arm/configs/mx21_defconfig
--- a/arch/arm/configs/mx21_defconfig
+++ b/arch/arm/configs/mx21_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/mx27_defconfig b/arch/arm/configs/mx27_defconfig
--- a/arch/arm/configs/mx27_defconfig
+++ b/arch/arm/configs/mx27_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/mx3_defconfig b/arch/arm/configs/mx3_defconfig
--- a/arch/arm/configs/mx3_defconfig
+++ b/arch/arm/configs/mx3_defconfig
@@ -4,7 +4,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pcontrol_g20_defconfig b/arch/arm/configs/pcontrol_g20_defconfig
--- a/arch/arm/configs/pcontrol_g20_defconfig
+++ b/arch/arm/configs/pcontrol_g20_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_SHMEM is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="oe1"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/stmp378x_defconfig b/arch/arm/configs/stmp378x_defconfig
--- a/arch/arm/configs/stmp378x_defconfig
+++ b/arch/arm/configs/stmp378x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/stmp37xx_defconfig b/arch/arm/configs/stmp37xx_defconfig
--- a/arch/arm/configs/stmp37xx_defconfig
+++ b/arch/arm/configs/stmp37xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/sx1_defconfig b/arch/arm/configs/sx1_defconfig
--- a/arch/arm/configs/sx1_defconfig
+++ b/arch/arm/configs/sx1_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_BUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/u300_defconfig b/arch/arm/configs/u300_defconfig
--- a/arch/arm/configs/u300_defconfig
+++ b/arch/arm/configs/u300_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_AIO is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SHMEM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -1,8 +1,8 @@
 config AVR32
 	def_bool y
-	# With EMBEDDED=n, we get lots of stuff automatically selected
+	# With EXPERT=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
-	select EMBEDDED
+	select EXPERT
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 # CONFIG_AIO is not set
 CONFIG_SLAB=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_ELF_CORE is not set
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
diff --git a/arch/cris/configs/artpec_3_defconfig b/arch/cris/configs/artpec_3_defconfig
--- a/arch/cris/configs/artpec_3_defconfig
+++ b/arch/cris/configs/artpec_3_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etrax-100lx_v2_defconfig b/arch/cris/configs/etrax-100lx_v2_defconfig
--- a/arch/cris/configs/etrax-100lx_v2_defconfig
+++ b/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/cris/configs/etraxfs_defconfig b/arch/cris/configs/etraxfs_defconfig
--- a/arch/cris/configs/etraxfs_defconfig
+++ b/arch/cris/configs/etraxfs_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/frv/defconfig b/arch/frv/defconfig
--- a/arch/frv/defconfig
+++ b/arch/frv/defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_MMU=y
 CONFIG_FRV_OUTOFLINE_ATOMIC_OPS=y
diff --git a/arch/h8300/defconfig b/arch/h8300/defconfig
--- a/arch/h8300/defconfig
+++ b/arch/h8300/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_UID16 is not set
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.nommu_defconfig b/arch/m32r/configs/mappi.nommu_defconfig
--- a/arch/m32r/configs/mappi.nommu_defconfig
+++ b/arch/m32r/configs/mappi.nommu_defconfig
@@ -3,7 +3,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.opsp_defconfig b/arch/m32r/configs/mappi2.opsp_defconfig
--- a/arch/m32r/configs/mappi2.opsp_defconfig
+++ b/arch/m32r/configs/mappi2.opsp_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi2.vdec2_defconfig b/arch/m32r/configs/mappi2.vdec2_defconfig
--- a/arch/m32r/configs/mappi2.vdec2_defconfig
+++ b/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -5,7 +5,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/oaks32r_defconfig b/arch/m32r/configs/oaks32r_defconfig
--- a/arch/m32r/configs/oaks32r_defconfig
+++ b/arch/m32r/configs/oaks32r_defconfig
@@ -2,7 +2,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/m68knommu/configs/m5208evb_defconfig b/arch/m68knommu/configs/m5208evb_defconfig
--- a/arch/m68knommu/configs/m5208evb_defconfig
+++ b/arch/m68knommu/configs/m5208evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5249evb_defconfig b/arch/m68knommu/configs/m5249evb_defconfig
--- a/arch/m68knommu/configs/m5249evb_defconfig
+++ b/arch/m68knommu/configs/m5249evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5272c3_defconfig b/arch/m68knommu/configs/m5272c3_defconfig
--- a/arch/m68knommu/configs/m5272c3_defconfig
+++ b/arch/m68knommu/configs/m5272c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5275evb_defconfig b/arch/m68knommu/configs/m5275evb_defconfig
--- a/arch/m68knommu/configs/m5275evb_defconfig
+++ b/arch/m68knommu/configs/m5275evb_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5307c3_defconfig b/arch/m68knommu/configs/m5307c3_defconfig
--- a/arch/m68knommu/configs/m5307c3_defconfig
+++ b/arch/m68knommu/configs/m5307c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/configs/m5407c3_defconfig b/arch/m68knommu/configs/m5407c3_defconfig
--- a/arch/m68knommu/configs/m5407c3_defconfig
+++ b/arch/m68knommu/configs/m5407c3_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/m68knommu/defconfig b/arch/m68knommu/defconfig
--- a/arch/m68knommu/defconfig
+++ b/arch/m68knommu/defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -7,7 +7,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -6,7 +6,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -7,7 +7,7 @@ config TRACE_IRQFLAGS_SUPPORT
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	depends on SYS_HAS_EARLY_PRINTK
 	default y
 	help
diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -14,7 +14,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -21,7 +21,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_LZMA=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_TINY_RCU=y
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -26,7 +26,7 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/capcella_defconfig b/arch/mips/configs/capcella_defconfig
--- a/arch/mips/configs/capcella_defconfig
+++ b/arch/mips/configs/capcella_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/cavium-octeon_defconfig b/arch/mips/configs/cavium-octeon_defconfig
--- a/arch/mips/configs/cavium-octeon_defconfig
+++ b/arch/mips/configs/cavium-octeon_defconfig
@@ -15,7 +15,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -11,7 +11,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1100_defconfig b/arch/mips/configs/db1100_defconfig
--- a/arch/mips/configs/db1100_defconfig
+++ b/arch/mips/configs/db1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/db1500_defconfig b/arch/mips/configs/db1500_defconfig
--- a/arch/mips/configs/db1500_defconfig
+++ b/arch/mips/configs/db1500_defconfig
@@ -10,7 +10,7 @@ CONFIG_LOCALVERSION="-db1500"
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/db1550_defconfig b/arch/mips/configs/db1550_defconfig
--- a/arch/mips/configs/db1550_defconfig
+++ b/arch/mips/configs/db1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/e55_defconfig b/arch/mips/configs/e55_defconfig
--- a/arch/mips/configs/e55_defconfig
+++ b/arch/mips/configs/e55_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -17,7 +17,7 @@ CONFIG_NAMESPACES=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -11,7 +11,7 @@ CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -17,7 +17,7 @@ CONFIG_IPC_NS=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -4,7 +4,7 @@ CONFIG_TOSHIBA_JMR3927=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/lasat_defconfig b/arch/mips/configs/lasat_defconfig
--- a/arch/mips/configs/lasat_defconfig
+++ b/arch/mips/configs/lasat_defconfig
@@ -8,7 +8,7 @@ CONFIG_HZ_1000=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -21,7 +21,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -15,7 +15,7 @@ CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
 CONFIG_PID_NS=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -9,7 +9,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mipssim_defconfig b/arch/mips/configs/mipssim_defconfig
--- a/arch/mips/configs/mipssim_defconfig
+++ b/arch/mips/configs/mipssim_defconfig
@@ -7,7 +7,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/mpc30x_defconfig b/arch/mips/configs/mpc30x_defconfig
--- a/arch/mips/configs/mpc30x_defconfig
+++ b/arch/mips/configs/mpc30x_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOCALVERSION="-pmc"
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SHMEM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -11,7 +11,7 @@ CONFIG_AUDIT=y
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/mips/configs/pb1100_defconfig b/arch/mips/configs/pb1100_defconfig
--- a/arch/mips/configs/pb1100_defconfig
+++ b/arch/mips/configs/pb1100_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1200_defconfig b/arch/mips/configs/pb1200_defconfig
--- a/arch/mips/configs/pb1200_defconfig
+++ b/arch/mips/configs/pb1200_defconfig
@@ -12,7 +12,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1500_defconfig b/arch/mips/configs/pb1500_defconfig
--- a/arch/mips/configs/pb1500_defconfig
+++ b/arch/mips/configs/pb1500_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pb1550_defconfig b/arch/mips/configs/pb1550_defconfig
--- a/arch/mips/configs/pb1550_defconfig
+++ b/arch/mips/configs/pb1550_defconfig
@@ -11,7 +11,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/pnx8335-stb225_defconfig b/arch/mips/configs/pnx8335-stb225_defconfig
--- a/arch/mips/configs/pnx8335-stb225_defconfig
+++ b/arch/mips/configs/pnx8335-stb225_defconfig
@@ -11,7 +11,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/powertv_defconfig b/arch/mips/configs/powertv_defconfig
--- a/arch/mips/configs/powertv_defconfig
+++ b/arch/mips/configs/powertv_defconfig
@@ -14,7 +14,7 @@ CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PCSPKR_PLATFORM is not set
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -13,7 +13,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -15,7 +15,7 @@ CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_PCSPKR_PLATFORM is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/workpad_defconfig b/arch/mips/configs/workpad_defconfig
--- a/arch/mips/configs/workpad_defconfig
+++ b/arch/mips/configs/workpad_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/configs/wrppmc_defconfig b/arch/mips/configs/wrppmc_defconfig
--- a/arch/mips/configs/wrppmc_defconfig
+++ b/arch/mips/configs/wrppmc_defconfig
@@ -7,7 +7,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_EPOLL is not set
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -4,7 +4,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -15,7 +15,7 @@ CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -8,7 +8,7 @@ CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/40x/acadia_defconfig b/arch/powerpc/configs/40x/acadia_defconfig
--- a/arch/powerpc/configs/40x/acadia_defconfig
+++ b/arch/powerpc/configs/40x/acadia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/ep405_defconfig b/arch/powerpc/configs/40x/ep405_defconfig
--- a/arch/powerpc/configs/40x/ep405_defconfig
+++ b/arch/powerpc/configs/40x/ep405_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/hcu4_defconfig b/arch/powerpc/configs/40x/hcu4_defconfig
--- a/arch/powerpc/configs/40x/hcu4_defconfig
+++ b/arch/powerpc/configs/40x/hcu4_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/kilauea_defconfig b/arch/powerpc/configs/40x/kilauea_defconfig
--- a/arch/powerpc/configs/40x/kilauea_defconfig
+++ b/arch/powerpc/configs/40x/kilauea_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/makalu_defconfig b/arch/powerpc/configs/40x/makalu_defconfig
--- a/arch/powerpc/configs/40x/makalu_defconfig
+++ b/arch/powerpc/configs/40x/makalu_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/40x/walnut_defconfig b/arch/powerpc/configs/40x/walnut_defconfig
--- a/arch/powerpc/configs/40x/walnut_defconfig
+++ b/arch/powerpc/configs/40x/walnut_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/arches_defconfig b/arch/powerpc/configs/44x/arches_defconfig
--- a/arch/powerpc/configs/44x/arches_defconfig
+++ b/arch/powerpc/configs/44x/arches_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bamboo_defconfig b/arch/powerpc/configs/44x/bamboo_defconfig
--- a/arch/powerpc/configs/44x/bamboo_defconfig
+++ b/arch/powerpc/configs/44x/bamboo_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/bluestone_defconfig b/arch/powerpc/configs/44x/bluestone_defconfig
--- a/arch/powerpc/configs/44x/bluestone_defconfig
+++ b/arch/powerpc/configs/44x/bluestone_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_PCI_QUIRKS is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/44x/canyonlands_defconfig b/arch/powerpc/configs/44x/canyonlands_defconfig
--- a/arch/powerpc/configs/44x/canyonlands_defconfig
+++ b/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -6,7 +6,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -7,7 +7,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/lite5200b_defconfig b/arch/powerpc/configs/52xx/lite5200b_defconfig
--- a/arch/powerpc/configs/52xx/lite5200b_defconfig
+++ b/arch/powerpc/configs/52xx/lite5200b_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -8,7 +8,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_KALLSYMS is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/kmeter1_defconfig b/arch/powerpc/configs/83xx/kmeter1_defconfig
--- a/arch/powerpc/configs/83xx/kmeter1_defconfig
+++ b/arch/powerpc/configs/83xx/kmeter1_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
--- a/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_mds_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/83xx/sbc834x_defconfig b/arch/powerpc/configs/83xx/sbc834x_defconfig
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig
+++ b/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_KSI8560=y
 CONFIG_CPM2=y
diff --git a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
--- a/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8540_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8540_ADS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
--- a/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
+++ b/arch/powerpc/configs/85xx/mpc8560_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC8560_ADS=y
 CONFIG_BINFMT_MISC=y
diff --git a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
--- a/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
+++ b/arch/powerpc/configs/85xx/mpc85xx_cds_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_MPC85xx_CDS=y
 CONFIG_NO_HZ=y
diff --git a/arch/powerpc/configs/85xx/sbc8548_defconfig b/arch/powerpc/configs/85xx/sbc8548_defconfig
--- a/arch/powerpc/configs/85xx/sbc8548_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8548=y
diff --git a/arch/powerpc/configs/85xx/sbc8560_defconfig b/arch/powerpc/configs/85xx/sbc8560_defconfig
--- a/arch/powerpc/configs/85xx/sbc8560_defconfig
+++ b/arch/powerpc/configs/85xx/sbc8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_SBC8560=y
diff --git a/arch/powerpc/configs/85xx/socrates_defconfig b/arch/powerpc/configs/85xx/socrates_defconfig
--- a/arch/powerpc/configs/85xx/socrates_defconfig
+++ b/arch/powerpc/configs/85xx/socrates_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8540_defconfig b/arch/powerpc/configs/85xx/tqm8540_defconfig
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8541_defconfig b/arch/powerpc/configs/85xx/tqm8541_defconfig
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8548_defconfig b/arch/powerpc/configs/85xx/tqm8548_defconfig
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/powerpc/configs/85xx/tqm8555_defconfig b/arch/powerpc/configs/85xx/tqm8555_defconfig
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/tqm8560_defconfig b/arch/powerpc/configs/85xx/tqm8560_defconfig
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_EPOLL is not set
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -11,7 +11,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_ELF_CORE is not set
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -11,7 +11,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/e55xx_smp_defconfig b/arch/powerpc/configs/e55xx_smp_defconfig
--- a/arch/powerpc/configs/e55xx_smp_defconfig
+++ b/arch/powerpc/configs/e55xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -6,7 +6,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/configs/holly_defconfig b/arch/powerpc/configs/holly_defconfig
--- a/arch/powerpc/configs/holly_defconfig
+++ b/arch/powerpc/configs/holly_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_MODULES=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_SLAB=y
 # CONFIG_IOSCHED_CFQ is not set
diff --git a/arch/powerpc/configs/mgsuvd_defconfig b/arch/powerpc/configs/mgsuvd_defconfig
--- a/arch/powerpc/configs/mgsuvd_defconfig
+++ b/arch/powerpc/configs/mgsuvd_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff --git a/arch/powerpc/configs/mpc7448_hpc2_defconfig b/arch/powerpc/configs/mpc7448_hpc2_defconfig
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig
+++ b/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -4,7 +4,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -2,7 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -3,7 +3,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -12,7 +12,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_HOTPLUG is not set
 # CONFIG_BUG is not set
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -10,7 +10,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -4,7 +4,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -5,7 +5,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -3,7 +3,7 @@ CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_PPC_CHRP is not set
 # CONFIG_PPC_PMAC is not set
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -8,7 +8,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_PERF_EVENTS is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -1,7 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_ELF_CORE is not set
 # CONFIG_BASE_FULL is not set
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -7,7 +7,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
 CONFIG_PERF_COUNTERS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
--- a/arch/powerpc/platforms/iseries/Kconfig
+++ b/arch/powerpc/platforms/iseries/Kconfig
@@ -2,7 +2,7 @@ config PPC_ISERIES
 	bool "IBM Legacy iSeries"
 	depends on PPC64 && PPC_BOOK3S
 	select PPC_INDIRECT_IO
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 
 menu "iSeries device drivers"
 	depends on PPC_ISERIES
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -10,7 +10,7 @@ config PPC_PSERIES
 	select RTAS_ERROR_LOGGING
 	select PPC_UDBG_16550
 	select PPC_NATIVE
-	select PPC_PCI_CHOICE if EMBEDDED
+	select PPC_PCI_CHOICE if EXPERT
 	default y
 
 config PPC_SPLPAR
@@ -24,9 +24,9 @@ config PPC_SPLPAR
 	  two or more partitions.
 
 config EEH
-	bool "PCI Extended Error Handling (EEH)" if EMBEDDED
+	bool "PCI Extended Error Handling (EEH)" if EXPERT
 	depends on PPC_PSERIES && PCI
-	default y if !EMBEDDED
+	default y if !EXPERT
 
 config PSERIES_MSI
        bool
diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -9,7 +9,7 @@ CONFIG_LOG_BUF_SHIFT=12
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_SLAB=y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -1,6 +1,6 @@
 config SUPERH
 	def_bool y
-	select EMBEDDED
+	select EXPERT
 	select HAVE_CLK
 	select HAVE_IDE if HAS_IOPORT
 	select HAVE_MEMBLOCK
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -220,7 +220,7 @@ config FORCE_MAX_ZONEORDER
 
 choice
 	depends on !TILEGX
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	---help---
 	  Select the desired split between kernel and user memory.
diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -3,7 +3,7 @@ menu "Kernel hacking"
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
+	bool "Early printk" if EXPERT && DEBUG_KERNEL
 	default y
 	help
 	  Write kernel log output directly via the hypervisor console.
diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -3,7 +3,7 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="usr/contents.txt"
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_MODULES=y
diff --git a/arch/um/defconfig b/arch/um/defconfig
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -133,7 +133,7 @@ CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_BLK_DEV_INITRD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -604,7 +604,7 @@ config APB_TIMER
 # The code disables itself when not needed.
 config DMI
 	default y
-	bool "Enable DMI scanning" if EMBEDDED
+	bool "Enable DMI scanning" if EXPERT
 	---help---
 	  Enabled scanning of DMI to identify machine quirks. Say Y
 	  here unless you have verified that your setup is not
@@ -612,7 +612,7 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EMBEDDED
+	bool "GART IOMMU support" if EXPERT
 	default y
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
@@ -862,7 +862,7 @@ config X86_THERMAL_VECTOR
 	depends on X86_MCE_INTEL
 
 config VM86
-	bool "Enable VM86 support" if EMBEDDED
+	bool "Enable VM86 support" if EXPERT
 	default y
 	depends on X86_32
 	---help---
@@ -1046,7 +1046,7 @@ endchoice
 
 choice
 	depends on EXPERIMENTAL
-	prompt "Memory split" if EMBEDDED
+	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	depends on X86_32
 	---help---
@@ -1108,7 +1108,7 @@ config ARCH_DMA_ADDR_T_64BIT
 	def_bool X86_64 || HIGHMEM64G
 
 config DIRECT_GBPAGES
-	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
+	bool "Enable 1GB pages for kernel pagetables" if EXPERT
 	default y
 	depends on X86_64
 	---help---
@@ -1342,7 +1342,7 @@ config MATH_EMULATION
 
 config MTRR
 	def_bool y
-	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
+	prompt "MTRR (Memory Type Range Register) support" if EXPERT
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1408,7 +1408,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	def_bool y
-	prompt "x86 PAT support" if EMBEDDED
+	prompt "x86 PAT support" if EXPERT
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
@@ -1512,7 +1512,7 @@ config KEXEC_JUMP
 	  code in physical address mode via KEXEC
 
 config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
 	default "0x1000000"
 	---help---
 	  This gives the physical address where the kernel is loaded.
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -421,7 +421,7 @@ config X86_DEBUGCTLMSR
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
 
 menuconfig PROCESSOR_SELECT
-	bool "Supported processor vendors" if EMBEDDED
+	bool "Supported processor vendors" if EXPERT
 	---help---
 	  This lets you choose what x86 vendor support code your kernel
 	  will include.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -31,7 +31,7 @@ config X86_VERBOSE_BOOTUP
 	  see errors. Disable this if you want silent bootup.
 
 config EARLY_PRINTK
-	bool "Early printk" if EMBEDDED
+	bool "Early printk" if EXPERT
 	default y
 	---help---
 	  Write kernel log output directly into the VGA buffer or to a serial
@@ -127,7 +127,7 @@ config DEBUG_NX_TEST
 
 config DOUBLEFAULT
 	default y
-	bool "Enable doublefault exception handler" if EMBEDDED
+	bool "Enable doublefault exception handler" if EXPERT
 	depends on X86_32
 	---help---
 	  This option allows trapping of rare doublefault exceptions that
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -32,7 +32,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_HOTPLUG is not set
 CONFIG_KOBJECT_UEVENT=y
 # CONFIG_IKCONFIG is not set
-# CONFIG_EMBEDDED is not set
+# CONFIG_EXPERT is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -55,7 +55,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -55,7 +55,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
+CONFIG_EXPERT=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
