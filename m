Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JRJ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:57:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36133 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2JRJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:57:27 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] Remove CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC from all defconfigs
Date: Thu, 18 Oct 2012 11:55:51 +0200
Message-Id: <1350554151-8767-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350554151-8767-1-git-send-email-holler@ahsoftware.de>
References: <1350554151-8767-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those two options are now enabled by default.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/configs/ag5evm_defconfig                 | 2 --
 arch/arm/configs/ap4evb_defconfig                 | 2 --
 arch/arm/configs/armadillo800eva_defconfig        | 2 --
 arch/arm/configs/at91rm9200_defconfig             | 2 --
 arch/arm/configs/at91sam9261_defconfig            | 2 --
 arch/arm/configs/at91sam9263_defconfig            | 2 --
 arch/arm/configs/bonito_defconfig                 | 2 --
 arch/arm/configs/cam60_defconfig                  | 2 --
 arch/arm/configs/cm_x2xx_defconfig                | 2 --
 arch/arm/configs/cm_x300_defconfig                | 2 --
 arch/arm/configs/cns3420vb_defconfig              | 2 --
 arch/arm/configs/colibri_pxa270_defconfig         | 2 --
 arch/arm/configs/da8xx_omapl_defconfig            | 2 --
 arch/arm/configs/davinci_all_defconfig            | 2 --
 arch/arm/configs/em_x270_defconfig                | 2 --
 arch/arm/configs/ep93xx_defconfig                 | 2 --
 arch/arm/configs/g3evm_defconfig                  | 2 --
 arch/arm/configs/g4evm_defconfig                  | 2 --
 arch/arm/configs/h5000_defconfig                  | 2 --
 arch/arm/configs/integrator_defconfig             | 2 --
 arch/arm/configs/iop13xx_defconfig                | 2 --
 arch/arm/configs/kota2_defconfig                  | 2 --
 arch/arm/configs/kzm9d_defconfig                  | 2 --
 arch/arm/configs/kzm9g_defconfig                  | 2 --
 arch/arm/configs/lpc32xx_defconfig                | 2 --
 arch/arm/configs/mackerel_defconfig               | 2 --
 arch/arm/configs/magician_defconfig               | 2 --
 arch/arm/configs/marzen_defconfig                 | 2 --
 arch/arm/configs/msm_defconfig                    | 2 --
 arch/arm/configs/mxs_defconfig                    | 2 --
 arch/arm/configs/netx_defconfig                   | 2 --
 arch/arm/configs/nhk8815_defconfig                | 2 --
 arch/arm/configs/omap1_defconfig                  | 1 -
 arch/arm/configs/omap2plus_defconfig              | 2 --
 arch/arm/configs/pcm027_defconfig                 | 2 --
 arch/arm/configs/s3c2410_defconfig                | 2 --
 arch/arm/configs/socfpga_defconfig                | 2 --
 arch/arm/configs/tegra_defconfig                  | 2 --
 arch/arm/configs/trizeps4_defconfig               | 2 --
 arch/arm/configs/vexpress_defconfig               | 2 --
 arch/arm/configs/xcep_defconfig                   | 2 --
 arch/arm64/configs/defconfig                      | 2 --
 arch/blackfin/configs/BF518F-EZBRD_defconfig      | 2 --
 arch/blackfin/configs/BF526-EZBRD_defconfig       | 2 --
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig | 2 --
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    | 2 --
 arch/blackfin/configs/BF527-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BF527-TLL6527M_defconfig    | 2 --
 arch/blackfin/configs/BF533-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BF533-STAMP_defconfig       | 2 --
 arch/blackfin/configs/BF537-STAMP_defconfig       | 2 --
 arch/blackfin/configs/BF538-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BF548-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BF561-ACVILON_defconfig     | 2 --
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   | 2 --
 arch/blackfin/configs/BF561-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BF609-EZKIT_defconfig       | 2 --
 arch/blackfin/configs/BlackStamp_defconfig        | 2 --
 arch/blackfin/configs/CM-BF527_defconfig          | 2 --
 arch/blackfin/configs/CM-BF533_defconfig          | 2 --
 arch/blackfin/configs/CM-BF537E_defconfig         | 2 --
 arch/blackfin/configs/CM-BF537U_defconfig         | 2 --
 arch/blackfin/configs/CM-BF548_defconfig          | 2 --
 arch/blackfin/configs/CM-BF561_defconfig          | 2 --
 arch/blackfin/configs/DNP5370_defconfig           | 2 --
 arch/blackfin/configs/TCM-BF518_defconfig         | 2 --
 arch/blackfin/configs/TCM-BF537_defconfig         | 2 --
 arch/hexagon/configs/comet_defconfig              | 2 --
 arch/ia64/configs/generic_defconfig               | 2 --
 arch/ia64/configs/gensparse_defconfig             | 2 --
 arch/ia64/configs/sim_defconfig                   | 2 --
 arch/ia64/configs/tiger_defconfig                 | 2 --
 arch/ia64/configs/xen_domu_defconfig              | 2 --
 arch/m32r/configs/m32104ut_defconfig              | 2 --
 arch/m32r/configs/m32700ut.smp_defconfig          | 2 --
 arch/m32r/configs/m32700ut.up_defconfig           | 2 --
 arch/m32r/configs/mappi.nommu_defconfig           | 1 -
 arch/m32r/configs/mappi.smp_defconfig             | 2 --
 arch/m32r/configs/mappi.up_defconfig              | 2 --
 arch/m32r/configs/mappi2.opsp_defconfig           | 1 -
 arch/m32r/configs/mappi2.vdec2_defconfig          | 1 -
 arch/m32r/configs/mappi3.smp_defconfig            | 2 --
 arch/m32r/configs/opsput_defconfig                | 1 -
 arch/microblaze/configs/mmu_defconfig             | 2 --
 arch/microblaze/configs/nommu_defconfig           | 2 --
 arch/mips/configs/bigsur_defconfig                | 2 --
 arch/mips/configs/cavium_octeon_defconfig         | 2 --
 arch/mips/configs/fuloong2e_defconfig             | 2 --
 arch/mips/configs/ip22_defconfig                  | 2 --
 arch/mips/configs/ip27_defconfig                  | 2 --
 arch/mips/configs/ip28_defconfig                  | 2 --
 arch/mips/configs/ip32_defconfig                  | 2 --
 arch/mips/configs/jazz_defconfig                  | 2 --
 arch/mips/configs/lemote2f_defconfig              | 2 --
 arch/mips/configs/ls1b_defconfig                  | 2 --
 arch/mips/configs/markeins_defconfig              | 2 --
 arch/mips/configs/pnx8550_jbs_defconfig           | 2 --
 arch/mips/configs/pnx8550_stb810_defconfig        | 2 --
 arch/mips/configs/rb532_defconfig                 | 2 --
 arch/mips/configs/rbtx49xx_defconfig              | 2 --
 arch/mips/configs/rm200_defconfig                 | 2 --
 arch/mips/configs/sead3_defconfig                 | 2 --
 arch/mips/configs/yosemite_defconfig              | 2 --
 arch/parisc/configs/712_defconfig                 | 2 --
 arch/parisc/configs/a500_defconfig                | 2 --
 arch/parisc/configs/b180_defconfig                | 2 --
 arch/parisc/configs/c3000_defconfig               | 2 --
 arch/parisc/configs/default_defconfig             | 2 --
 arch/powerpc/configs/40x/virtex_defconfig         | 2 --
 arch/powerpc/configs/44x/sam440ep_defconfig       | 1 -
 arch/powerpc/configs/44x/virtex5_defconfig        | 2 --
 arch/powerpc/configs/44x/warp_defconfig           | 2 --
 arch/powerpc/configs/52xx/pcm030_defconfig        | 2 --
 arch/powerpc/configs/85xx/ge_imp3a_defconfig      | 2 --
 arch/powerpc/configs/85xx/p1023rds_defconfig      | 2 --
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   | 2 --
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     | 2 --
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    | 2 --
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    | 2 --
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  | 2 --
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  | 2 --
 arch/powerpc/configs/86xx/sbc8641d_defconfig      | 2 --
 arch/powerpc/configs/amigaone_defconfig           | 2 --
 arch/powerpc/configs/cell_defconfig               | 2 --
 arch/powerpc/configs/celleb_defconfig             | 2 --
 arch/powerpc/configs/chroma_defconfig             | 2 --
 arch/powerpc/configs/chrp32_defconfig             | 2 --
 arch/powerpc/configs/corenet32_smp_defconfig      | 2 --
 arch/powerpc/configs/corenet64_smp_defconfig      | 2 --
 arch/powerpc/configs/ep8248e_defconfig            | 2 --
 arch/powerpc/configs/g5_defconfig                 | 2 --
 arch/powerpc/configs/gamecube_defconfig           | 2 --
 arch/powerpc/configs/linkstation_defconfig        | 2 --
 arch/powerpc/configs/maple_defconfig              | 2 --
 arch/powerpc/configs/mgcoge_defconfig             | 2 --
 arch/powerpc/configs/mpc8272_ads_defconfig        | 2 --
 arch/powerpc/configs/mpc85xx_defconfig            | 2 --
 arch/powerpc/configs/mpc85xx_smp_defconfig        | 2 --
 arch/powerpc/configs/mpc86xx_defconfig            | 2 --
 arch/powerpc/configs/pmac32_defconfig             | 2 --
 arch/powerpc/configs/ppc64_defconfig              | 2 --
 arch/powerpc/configs/ppc64e_defconfig             | 2 --
 arch/powerpc/configs/pq2fads_defconfig            | 2 --
 arch/powerpc/configs/pseries_defconfig            | 2 --
 arch/powerpc/configs/wii_defconfig                | 2 --
 arch/s390/defconfig                               | 2 --
 arch/sh/configs/apsh4a3a_defconfig                | 2 --
 arch/sh/configs/apsh4ad0a_defconfig               | 2 --
 arch/sh/configs/ecovec24-romimage_defconfig       | 2 --
 arch/sh/configs/edosk7760_defconfig               | 2 --
 arch/sh/configs/espt_defconfig                    | 2 --
 arch/sh/configs/hp6xx_defconfig                   | 2 --
 arch/sh/configs/kfr2r09-romimage_defconfig        | 2 --
 arch/sh/configs/kfr2r09_defconfig                 | 2 --
 arch/sh/configs/migor_defconfig                   | 2 --
 arch/sh/configs/r7780mp_defconfig                 | 2 --
 arch/sh/configs/r7785rp_defconfig                 | 2 --
 arch/sh/configs/rsk7201_defconfig                 | 1 -
 arch/sh/configs/rsk7203_defconfig                 | 1 -
 arch/sh/configs/rsk7264_defconfig                 | 1 -
 arch/sh/configs/sdk7780_defconfig                 | 2 --
 arch/sh/configs/sdk7786_defconfig                 | 2 --
 arch/sh/configs/se7722_defconfig                  | 2 --
 arch/sh/configs/se7750_defconfig                  | 2 --
 arch/sh/configs/se7780_defconfig                  | 2 --
 arch/sh/configs/sh2007_defconfig                  | 1 -
 arch/sh/configs/sh7763rdp_defconfig               | 2 --
 arch/sh/configs/sh7785lcr_32bit_defconfig         | 2 --
 arch/sh/configs/sh7785lcr_defconfig               | 2 --
 arch/sh/configs/shx3_defconfig                    | 2 --
 arch/sh/configs/titan_defconfig                   | 2 --
 arch/sh/configs/ul2_defconfig                     | 2 --
 arch/sh/configs/urquell_defconfig                 | 2 --
 arch/um/defconfig                                 | 2 --
 arch/xtensa/configs/common_defconfig              | 1 -
 arch/xtensa/configs/iss_defconfig                 | 1 -
 arch/xtensa/configs/s6105_defconfig               | 2 --
 177 files changed, 342 deletions(-)

diff --git a/arch/arm/configs/ag5evm_defconfig b/arch/arm/configs/ag5evm_defconfig
index 212ead3..888039e 100644
--- a/arch/arm/configs/ag5evm_defconfig
+++ b/arch/arm/configs/ag5evm_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
diff --git a/arch/arm/configs/ap4evb_defconfig b/arch/arm/configs/ap4evb_defconfig
index 2eef85e..ade9be0c 100644
--- a/arch/arm/configs/ap4evb_defconfig
+++ b/arch/arm/configs/ap4evb_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/armadillo800eva_defconfig b/arch/arm/configs/armadillo800eva_defconfig
index f78d259..1c3cfd2 100644
--- a/arch/arm/configs/armadillo800eva_defconfig
+++ b/arch/arm/configs/armadillo800eva_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
diff --git a/arch/arm/configs/at91rm9200_defconfig b/arch/arm/configs/at91rm9200_defconfig
index 4ae57a3..15a6498 100644
--- a/arch/arm/configs/at91rm9200_defconfig
+++ b/arch/arm/configs/at91rm9200_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/at91sam9261_defconfig b/arch/arm/configs/at91sam9261_defconfig
index 1e8712e..f03a568 100644
--- a/arch/arm/configs/at91sam9261_defconfig
+++ b/arch/arm/configs/at91sam9261_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_EMBEDDED=y
diff --git a/arch/arm/configs/at91sam9263_defconfig b/arch/arm/configs/at91sam9263_defconfig
index d2050ca..1d3c26e 100644
--- a/arch/arm/configs/at91sam9263_defconfig
+++ b/arch/arm/configs/at91sam9263_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_EMBEDDED=y
diff --git a/arch/arm/configs/bonito_defconfig b/arch/arm/configs/bonito_defconfig
index 5457108..da737cb 100644
--- a/arch/arm/configs/bonito_defconfig
+++ b/arch/arm/configs/bonito_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index 1457971..ea5c857 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -5,8 +5,6 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..81a6192 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index f4b7672..f95e0ec 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-cm-x300"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index 313627a..d6371e7 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..c6b54b7 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -3,8 +3,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index 88ccde0..f00a827 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 67b5abb6..462e7fa 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..730b3bc 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 806005a..151ec52 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/g3evm_defconfig b/arch/arm/configs/g3evm_defconfig
index 4a336ab..7e8cf7f 100644
--- a/arch/arm/configs/g3evm_defconfig
+++ b/arch/arm/configs/g3evm_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/g4evm_defconfig b/arch/arm/configs/g4evm_defconfig
index 21c6d03..a2eeeeb 100644
--- a/arch/arm/configs/g4evm_defconfig
+++ b/arch/arm/configs/g4evm_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index 37903e3..5bcfeab 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/integrator_defconfig b/arch/arm/configs/integrator_defconfig
index a8314c3..9e1bc01 100644
--- a/arch/arm/configs/integrator_defconfig
+++ b/arch/arm/configs/integrator_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_TINY_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_MODULES=y
diff --git a/arch/arm/configs/iop13xx_defconfig b/arch/arm/configs/iop13xx_defconfig
index 4fa94a1..60f1f6a 100644
--- a/arch/arm/configs/iop13xx_defconfig
+++ b/arch/arm/configs/iop13xx_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/arm/configs/kota2_defconfig b/arch/arm/configs/kota2_defconfig
index b7735d6..7b4f25a 100644
--- a/arch/arm/configs/kota2_defconfig
+++ b/arch/arm/configs/kota2_defconfig
@@ -1,8 +1,6 @@
 # CONFIG_ARM_PATCH_PHYS_VIRT is not set
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/arm/configs/kzm9d_defconfig b/arch/arm/configs/kzm9d_defconfig
index 8c49df6..28136f9 100644
--- a/arch/arm/configs/kzm9d_defconfig
+++ b/arch/arm/configs/kzm9d_defconfig
@@ -2,8 +2,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL_SYSCALL=y
diff --git a/arch/arm/configs/kzm9g_defconfig b/arch/arm/configs/kzm9g_defconfig
index c88b578..fc5f3d3 100644
--- a/arch/arm/configs/kzm9g_defconfig
+++ b/arch/arm/configs/kzm9g_defconfig
@@ -2,8 +2,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_NAMESPACES=y
 # CONFIG_UTS_NS is not set
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 92386b2..dc18861 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/arm/configs/mackerel_defconfig b/arch/arm/configs/mackerel_defconfig
index 306a2e2..d712314 100644
--- a/arch/arm/configs/mackerel_defconfig
+++ b/arch/arm/configs/mackerel_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index a691ef4..0c37e07 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/marzen_defconfig b/arch/arm/configs/marzen_defconfig
index 53382b6..6aadaba 100644
--- a/arch/arm/configs/marzen_defconfig
+++ b/arch/arm/configs/marzen_defconfig
@@ -2,8 +2,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_NO_HZ=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_EMBEDDED=y
diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 2b8f7af..5031479 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -1,6 +1,4 @@
 CONFIG_EXPERIMENTAL=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
 # CONFIG_BLK_DEV_BSG is not set
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index 048aaca..3fb08a1 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -4,8 +4,6 @@ CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
 # CONFIG_USER_NS is not set
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 9c0ad79..d725bbc 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 240b25e..a169559 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index dde2a1a..0d8656c 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -3,7 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 6230304..8296f45 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 2f136c3..f767949 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 193448f..a2aebbc 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=m
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
index 0ac1293..1d1aab8 100644
--- a/arch/arm/configs/socfpga_defconfig
+++ b/arch/arm/configs/socfpga_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index e2184f6..ab69231 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..b404459 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -3,8 +3,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/arm/configs/vexpress_defconfig b/arch/arm/configs/vexpress_defconfig
index f2de51f..cc1aa34 100644
--- a/arch/arm/configs/vexpress_defconfig
+++ b/arch/arm/configs/vexpress_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
index 721832f..0b954b9 100644
--- a/arch/arm/configs/xcep_defconfig
+++ b/arch/arm/configs/xcep_defconfig
@@ -3,8 +3,6 @@ CONFIG_LOCALVERSION=".xcep-itech"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 9212c78..809ba5d 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -7,8 +7,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 3830078..4483001 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 2f2c6ac..0b5026e 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index d95658f..4f3a7fa 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 91535c3..9ec4f8d 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 90b1753..d44ba0e 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
index cd0636b..b266ecb 100644
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="DEV_0-1_pre2010"
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 16273a9..811f530 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 0df2f92..a191868 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 91d3eda..dcf2ee6 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 972aa62..f9b17b4 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index e716fdf..7e3f667 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 9198837..9d5f306 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index e2a2fa5..379cb91 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 680730e..c27d07a 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BF609-EZKIT_defconfig b/arch/blackfin/configs/BF609-EZKIT_defconfig
index 13eb732..0d17624 100644
--- a/arch/blackfin/configs/BF609-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF609-EZKIT_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 7b982d0..3a14b16 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index c280a50..eed11fc 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index c940a1e..6555882 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 2e47df7..b641e09 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 6da629f..2cb6b1d 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 349922b..4ffee70 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 0456dea..e8d04a5 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 89162d0..dd40a09 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="DNP5370"
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index e4ed865..970f6b8 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index c1f45f1..f4f79a1 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_KERNEL_LZMA=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/hexagon/configs/comet_defconfig b/arch/hexagon/configs/comet_defconfig
index e324f65..ddc8680 100644
--- a/arch/hexagon/configs/comet_defconfig
+++ b/arch/hexagon/configs/comet_defconfig
@@ -11,8 +11,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EMBEDDED=y
diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 7913695..5970582 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index f8e9133..75dda69 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/ia64/configs/sim_defconfig b/arch/ia64/configs/sim_defconfig
index b4548a3..de76d08 100644
--- a/arch/ia64/configs/sim_defconfig
+++ b/arch/ia64/configs/sim_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_MODULES=y
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index a5a9e02..5d4989e 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/ia64/configs/xen_domu_defconfig b/arch/ia64/configs/xen_domu_defconfig
index 37b9b42..96226ab 100644
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/m32r/configs/m32104ut_defconfig b/arch/m32r/configs/m32104ut_defconfig
index be30e09..f1b6bdb 100644
--- a/arch/m32r/configs/m32104ut_defconfig
+++ b/arch/m32r/configs/m32104ut_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index a3d727e..3fb90c8 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index b833416..c7eb2d1 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m32r/configs/mappi.nommu_defconfig b/arch/m32r/configs/mappi.nommu_defconfig
index 7c90ce2..5dcd3d8 100644
--- a/arch/m32r/configs/mappi.nommu_defconfig
+++ b/arch/m32r/configs/mappi.nommu_defconfig
@@ -1,6 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 367d07c..54d346f 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index cb11384..7817656 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m32r/configs/mappi2.opsp_defconfig b/arch/m32r/configs/mappi2.opsp_defconfig
index 3bff779..8257736 100644
--- a/arch/m32r/configs/mappi2.opsp_defconfig
+++ b/arch/m32r/configs/mappi2.opsp_defconfig
@@ -1,7 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m32r/configs/mappi2.vdec2_defconfig b/arch/m32r/configs/mappi2.vdec2_defconfig
index 75246c9..21be256 100644
--- a/arch/m32r/configs/mappi2.vdec2_defconfig
+++ b/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -1,7 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index 27cefd4..58adb6b 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
index 50c6f52..2c6853d 100644
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -1,7 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index b3f5eec..4c301fd4 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 0249e4b..d1e12f7 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -3,8 +3,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 1cdff6b..6b75bd1 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -14,8 +14,6 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
diff --git a/arch/mips/configs/cavium_octeon_defconfig b/arch/mips/configs/cavium_octeon_defconfig
index 75165df..480984d 100644
--- a/arch/mips/configs/cavium_octeon_defconfig
+++ b/arch/mips/configs/cavium_octeon_defconfig
@@ -8,8 +8,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index e5b73de..22b1e23 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -9,8 +9,6 @@ CONFIG_LOCALVERSION="-fuloong2e"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_NAMESPACES=y
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 936ec5a..9a27371 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -6,8 +6,6 @@ CONFIG_HZ_1000=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 0e36abc..a0717ac 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -8,8 +8,6 @@ CONFIG_HZ_1000=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index 4dbf626..293594f7 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -3,8 +3,6 @@ CONFIG_ARC_CONSOLE=y
 CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 7bbd521..9a71a89 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_RELAY=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 0315ee3..40c4d21 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -5,8 +5,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b6acd2f..35662b9 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -13,8 +13,6 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/mips/configs/ls1b_defconfig b/arch/mips/configs/ls1b_defconfig
index 80cff8b..9465109 100644
--- a/arch/mips/configs/ls1b_defconfig
+++ b/arch/mips/configs/ls1b_defconfig
@@ -7,8 +7,6 @@ CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_NAMESPACES=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 636f82b..8b003be 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -5,8 +5,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/mips/configs/pnx8550_jbs_defconfig b/arch/mips/configs/pnx8550_jbs_defconfig
index 1d1f206..c2e54de 100644
--- a/arch/mips/configs/pnx8550_jbs_defconfig
+++ b/arch/mips/configs/pnx8550_jbs_defconfig
@@ -1,8 +1,6 @@
 CONFIG_PNX8550_JBS=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/pnx8550_stb810_defconfig b/arch/mips/configs/pnx8550_stb810_defconfig
index 15c66a5..16045c2 100644
--- a/arch/mips/configs/pnx8550_stb810_defconfig
+++ b/arch/mips/configs/pnx8550_stb810_defconfig
@@ -1,8 +1,6 @@
 CONFIG_PNX8550_STB810=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index b85b121..170910b 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -8,8 +8,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_TINY_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index 9cba856..37bbcdd 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -7,8 +7,6 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 # CONFIG_SECCOMP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 59d9d2f..2dc3130 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -7,8 +7,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/mips/configs/sead3_defconfig b/arch/mips/configs/sead3_defconfig
index e3eec68..8c99f01 100644
--- a/arch/mips/configs/sead3_defconfig
+++ b/arch/mips/configs/sead3_defconfig
@@ -7,8 +7,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_EMBEDDED=y
 CONFIG_SLAB=y
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
index f72d305..d1a5f30 100644
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -4,8 +4,6 @@ CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_HZ_1000=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_EXPERT=y
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index 0f90569..a96be1c 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index b647b18..84545db 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/parisc/configs/b180_defconfig b/arch/parisc/configs/b180_defconfig
index e289f5b..061c8ef 100644
--- a/arch/parisc/configs/b180_defconfig
+++ b/arch/parisc/configs/b180_defconfig
@@ -1,7 +1,5 @@
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_SLAB=y
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index 311ca36..6ab582d 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/parisc/configs/default_defconfig b/arch/parisc/configs/default_defconfig
index dfe88f6..5875538 100644
--- a/arch/parisc/configs/default_defconfig
+++ b/arch/parisc/configs/default_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/40x/virtex_defconfig b/arch/powerpc/configs/40x/virtex_defconfig
index 0a81e1f..40f6b8d 100644
--- a/arch/powerpc/configs/40x/virtex_defconfig
+++ b/arch/powerpc/configs/40x/virtex_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/44x/sam440ep_defconfig b/arch/powerpc/configs/44x/sam440ep_defconfig
index ca088cd..0d66892 100644
--- a/arch/powerpc/configs/44x/sam440ep_defconfig
+++ b/arch/powerpc/configs/44x/sam440ep_defconfig
@@ -2,7 +2,6 @@ CONFIG_44x=y
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/44x/virtex5_defconfig b/arch/powerpc/configs/44x/virtex5_defconfig
index 1eb3caf..8fb9d06 100644
--- a/arch/powerpc/configs/44x/virtex5_defconfig
+++ b/arch/powerpc/configs/44x/virtex5_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index 105bc56..b878d85 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-pika"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 22e7195..6d31559 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -4,8 +4,6 @@ CONFIG_LOCALVERSION="trunk"
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/85xx/ge_imp3a_defconfig b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
index f8c51a4..60ff56e 100644
--- a/arch/powerpc/configs/85xx/ge_imp3a_defconfig
+++ b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
@@ -7,8 +7,6 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_SPARSE_IRQ=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 # CONFIG_UTS_NS is not set
 # CONFIG_IPC_NS is not set
 # CONFIG_USER_NS is not set
diff --git a/arch/powerpc/configs/85xx/p1023rds_defconfig b/arch/powerpc/configs/85xx/p1023rds_defconfig
index b80bcc6..4094769 100644
--- a/arch/powerpc/configs/85xx/p1023rds_defconfig
+++ b/arch/powerpc/configs/85xx/p1023rds_defconfig
@@ -9,8 +9,6 @@ CONFIG_AUDIT=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index 1cd6fcb..6cb1528 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -6,8 +6,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index da731c2..28d94bb 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index 2149360..fcf5e47 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index af2e8e1..18e64e1 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index c09598b..e444260 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
index f51c7eb..114b9fc 100644
--- a/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 0a92ca0..6174f1f 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_RELAY=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/amigaone_defconfig b/arch/powerpc/configs/amigaone_defconfig
index b6d49da..a46fe0b 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index 22a403d..740de33 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -5,8 +5,6 @@ CONFIG_SMP=y
 CONFIG_NR_CPUS=4
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
diff --git a/arch/powerpc/configs/celleb_defconfig b/arch/powerpc/configs/celleb_defconfig
index 895449e..cb22f42 100644
--- a/arch/powerpc/configs/celleb_defconfig
+++ b/arch/powerpc/configs/celleb_defconfig
@@ -5,8 +5,6 @@ CONFIG_SMP=y
 CONFIG_NR_CPUS=4
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index 29bb11e..baebcae 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -13,8 +13,6 @@ CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=19
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEVICE=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index b20554e..b4138fb 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/corenet32_smp_defconfig b/arch/powerpc/configs/corenet32_smp_defconfig
index 1c0f243..85e6aa7 100644
--- a/arch/powerpc/configs/corenet32_smp_defconfig
+++ b/arch/powerpc/configs/corenet32_smp_defconfig
@@ -8,8 +8,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 88fa5c4..be5c257 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -9,8 +9,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index fceffb3..ad1fb6e 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -1,6 +1,4 @@
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 07b7f2a..7d802ff 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -5,8 +5,6 @@ CONFIG_NR_CPUS=4
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
index 9ef2cc1..216c9b2 100644
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-gcn"
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 8a874b9..202f803 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 02ac96b..90e0352 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -4,8 +4,6 @@ CONFIG_NR_CPUS=4
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=m
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index 8fa84f1..e6368c9 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_RD_GZIP is not set
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index 6a22400..d63d03e 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -1,6 +1,4 @@
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_EXPERT=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index cf815e8..9faf0b4 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -8,8 +8,6 @@ CONFIG_AUDIT=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index 502cd9e..629530e 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -10,8 +10,6 @@ CONFIG_AUDIT=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
index a1cc817..fe85af8 100644
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -5,8 +5,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 29767a8..78f32f7 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -3,8 +3,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 6d03530..462d3e0 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -7,8 +7,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index f55c276..9e8687c 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -6,8 +6,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_TASKSTATS=y
 CONFIG_TASK_DELAY_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_BLK_DEV_INITRD=y
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index baad8db..bcda27b 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -1,6 +1,4 @@
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 1f710a3..781c7ea 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -12,8 +12,6 @@ CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_DEVICE=y
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index 1e2b7d0..0e67f95 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_LOCALVERSION="-wii"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index b74400e..3c2f12f 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -10,8 +10,6 @@ CONFIG_AUDIT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
diff --git a/arch/sh/configs/apsh4a3a_defconfig b/arch/sh/configs/apsh4a3a_defconfig
index 6cb3279..5a54291 100644
--- a/arch/sh/configs/apsh4a3a_defconfig
+++ b/arch/sh/configs/apsh4a3a_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
diff --git a/arch/sh/configs/apsh4ad0a_defconfig b/arch/sh/configs/apsh4ad0a_defconfig
index 95ae23f..f16ad09 100644
--- a/arch/sh/configs/apsh4ad0a_defconfig
+++ b/arch/sh/configs/apsh4ad0a_defconfig
@@ -3,8 +3,6 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_RCU_TRACE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/arch/sh/configs/ecovec24-romimage_defconfig b/arch/sh/configs/ecovec24-romimage_defconfig
index 5fcb17b..f3f1132 100644
--- a/arch/sh/configs/ecovec24-romimage_defconfig
+++ b/arch/sh/configs/ecovec24-romimage_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_KALLSYMS is not set
diff --git a/arch/sh/configs/edosk7760_defconfig b/arch/sh/configs/edosk7760_defconfig
index e1077a0..17702af 100644
--- a/arch/sh/configs/edosk7760_defconfig
+++ b/arch/sh/configs/edosk7760_defconfig
@@ -3,8 +3,6 @@ CONFIG_LOCALVERSION="_edosk7760"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index 67cb109..6ca3206 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff --git a/arch/sh/configs/hp6xx_defconfig b/arch/sh/configs/hp6xx_defconfig
index 496edcd..5e1e314 100644
--- a/arch/sh/configs/hp6xx_defconfig
+++ b/arch/sh/configs/hp6xx_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 # CONFIG_SYSCTL_SYSCALL is not set
diff --git a/arch/sh/configs/kfr2r09-romimage_defconfig b/arch/sh/configs/kfr2r09-romimage_defconfig
index 029a506..2d4685a 100644
--- a/arch/sh/configs/kfr2r09-romimage_defconfig
+++ b/arch/sh/configs/kfr2r09-romimage_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_KALLSYMS is not set
diff --git a/arch/sh/configs/kfr2r09_defconfig b/arch/sh/configs/kfr2r09_defconfig
index fac13de..3d0123c 100644
--- a/arch/sh/configs/kfr2r09_defconfig
+++ b/arch/sh/configs/kfr2r09_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_KALLSYMS is not set
diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index cc61eda..06a26bc 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index 920b847..567f3c8 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
 # CONFIG_FUTEX is not set
diff --git a/arch/sh/configs/r7785rp_defconfig b/arch/sh/configs/r7785rp_defconfig
index c77da6b..7f9386a 100644
--- a/arch/sh/configs/r7785rp_defconfig
+++ b/arch/sh/configs/r7785rp_defconfig
@@ -5,8 +5,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
 CONFIG_RCU_TRACE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_SYSCTL_SYSCALL is not set
 CONFIG_SLAB=y
diff --git a/arch/sh/configs/rsk7201_defconfig b/arch/sh/configs/rsk7201_defconfig
index 5df916d..c86fcec 100644
--- a/arch/sh/configs/rsk7201_defconfig
+++ b/arch/sh/configs/rsk7201_defconfig
@@ -2,7 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
index 4e5229b..74bdc1c 100644
--- a/arch/sh/configs/rsk7203_defconfig
+++ b/arch/sh/configs/rsk7203_defconfig
@@ -3,7 +3,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff --git a/arch/sh/configs/rsk7264_defconfig b/arch/sh/configs/rsk7264_defconfig
index 1600426..9dd4c22 100644
--- a/arch/sh/configs/rsk7264_defconfig
+++ b/arch/sh/configs/rsk7264_defconfig
@@ -2,7 +2,6 @@ CONFIG_LOCALVERSION="uClinux RSK2+SH7264"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_SYSFS_DEPRECATED=y
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index ae11158..a2a5d0d 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -3,8 +3,6 @@ CONFIG_LOCALVERSION="_SDK7780"
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_RELAY=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 76a76a2..c77edbf 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -8,8 +8,6 @@ CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
 CONFIG_TREE_PREEMPT_RCU=y
 CONFIG_RCU_TRACE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/arch/sh/configs/se7722_defconfig b/arch/sh/configs/se7722_defconfig
index ae998c7..c122d41 100644
--- a/arch/sh/configs/se7722_defconfig
+++ b/arch/sh/configs/se7722_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_PROFILING=y
diff --git a/arch/sh/configs/se7750_defconfig b/arch/sh/configs/se7750_defconfig
index 912c985..f9f5a85 100644
--- a/arch/sh/configs/se7750_defconfig
+++ b/arch/sh/configs/se7750_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 # CONFIG_SYSCTL_SYSCALL is not set
diff --git a/arch/sh/configs/se7780_defconfig b/arch/sh/configs/se7780_defconfig
index c8c5e7f..03112e8 100644
--- a/arch/sh/configs/se7780_defconfig
+++ b/arch/sh/configs/se7780_defconfig
@@ -1,7 +1,5 @@
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 0d2f414..bb588da 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -5,7 +5,6 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
-CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index 4795364..9630fe4 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -1,7 +1,5 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 9bdcf72..e18a0b1 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_PERF_EVENTS=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/sh/configs/sh7785lcr_defconfig b/arch/sh/configs/sh7785lcr_defconfig
index 51561f5..37cdb28 100644
--- a/arch/sh/configs/sh7785lcr_defconfig
+++ b/arch/sh/configs/sh7785lcr_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index cd6c519..c49c830 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -5,8 +5,6 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
 CONFIG_RCU_TRACE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index e2cbd92..77f3705 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -2,8 +2,6 @@ CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 2d288b8..c0a54a3 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -1,8 +1,6 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_PROFILING=y
diff --git a/arch/sh/configs/urquell_defconfig b/arch/sh/configs/urquell_defconfig
index d7f89be..4385a4a 100644
--- a/arch/sh/configs/urquell_defconfig
+++ b/arch/sh/configs/urquell_defconfig
@@ -4,8 +4,6 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_DEBUG=y
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..a332cbb 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -144,8 +144,6 @@ CONFIG_TINY_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 # CONFIG_RCU_TRACE is not set
 # CONFIG_TREE_RCU_TRACE is not set
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CGROUPS=y
 # CONFIG_CGROUP_DEBUG is not set
diff --git a/arch/xtensa/configs/common_defconfig b/arch/xtensa/configs/common_defconfig
index a182a4e..cc0a8c7 100644
--- a/arch/xtensa/configs/common_defconfig
+++ b/arch/xtensa/configs/common_defconfig
@@ -31,7 +31,6 @@ CONFIG_SYSCTL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_HOTPLUG is not set
 CONFIG_KOBJECT_UEVENT=y
-# CONFIG_IKCONFIG is not set
 # CONFIG_EXPERT is not set
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index ddab37b..f27dc23 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -44,7 +44,6 @@ CONFIG_TREE_RCU=y
 CONFIG_RCU_FANOUT=32
 # CONFIG_RCU_FANOUT_EXACT is not set
 # CONFIG_TREE_RCU_TRACE is not set
-# CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index eaf1b8f..f78f8a4 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -41,8 +41,6 @@ CONFIG_PREEMPT_RCU=y
 # CONFIG_RCU_TRACE is not set
 # CONFIG_TREE_RCU_TRACE is not set
 # CONFIG_PREEMPT_RCU_TRACE is not set
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_GROUP_SCHED is not set
 # CONFIG_CGROUPS is not set
-- 
1.7.11.7

