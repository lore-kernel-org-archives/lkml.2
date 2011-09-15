Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab1IOUMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:12:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934521Ab1IOUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873440"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, davem@davemloft.net
Subject: [PATCH 13/27] Initconst section fixes for IDE
Date: Thu, 15 Sep 2011 13:09:40 -0700
Message-Id: <1316117394-21666-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: davem@davemloft.net
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/ide/aec62xx.c         |    2 +-
 drivers/ide/ali14xx.c         |    4 ++--
 drivers/ide/alim15x3.c        |    2 +-
 drivers/ide/amd74xx.c         |    2 +-
 drivers/ide/at91_ide.c        |    2 +-
 drivers/ide/atiixp.c          |    2 +-
 drivers/ide/cmd640.c          |    2 +-
 drivers/ide/cmd64x.c          |    2 +-
 drivers/ide/cs5520.c          |    2 +-
 drivers/ide/cs5530.c          |    2 +-
 drivers/ide/cs5535.c          |    2 +-
 drivers/ide/cy82c693.c        |    2 +-
 drivers/ide/dtc2278.c         |    2 +-
 drivers/ide/hpt366.c          |   24 ++++++++++++------------
 drivers/ide/ht6560b.c         |    2 +-
 drivers/ide/icside.c          |    2 +-
 drivers/ide/ide-pci-generic.c |    2 +-
 drivers/ide/it8172.c          |    2 +-
 drivers/ide/it8213.c          |    2 +-
 drivers/ide/it821x.c          |    2 +-
 drivers/ide/jmicron.c         |    2 +-
 drivers/ide/ns87415.c         |    2 +-
 drivers/ide/opti621.c         |    2 +-
 drivers/ide/pdc202xx_new.c    |    2 +-
 drivers/ide/pdc202xx_old.c    |    2 +-
 drivers/ide/piix.c            |    2 +-
 drivers/ide/qd65xx.c          |    2 +-
 drivers/ide/rz1000.c          |    2 +-
 drivers/ide/sc1200.c          |    2 +-
 drivers/ide/scc_pata.c        |    2 +-
 drivers/ide/serverworks.c     |    2 +-
 drivers/ide/siimage.c         |    2 +-
 drivers/ide/sis5513.c         |    2 +-
 drivers/ide/sl82c105.c        |    2 +-
 drivers/ide/slc90e66.c        |    2 +-
 drivers/ide/tc86c001.c        |    2 +-
 drivers/ide/triflex.c         |    2 +-
 drivers/ide/trm290.c          |    2 +-
 drivers/ide/tx4938ide.c       |    2 +-
 drivers/ide/tx4939ide.c       |    2 +-
 drivers/ide/umc8672.c         |    2 +-
 drivers/ide/via82cxxx.c       |    2 +-
 42 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/ide/aec62xx.c b/drivers/ide/aec62xx.c
index 57d00ca..0145194 100644
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -181,7 +181,7 @@ static const struct ide_port_ops atp86x_port_ops = {
 	.cable_detect		= atp86x_cable_detect,
 };
 
-static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
+static const struct ide_port_info aec62xx_chipsets[] __devinitconst = {
 	{	/* 0: AEC6210 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
index 25b9fe3..61b05d6 100644
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -52,13 +52,13 @@
 
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
-static const int ports[ALI_NUM_PORTS] __initdata =
+static const int ports[ALI_NUM_PORTS] __initconst =
 	{ 0x074, 0x0f4, 0x034, 0x0e4 };
 
 /* register initialization data */
 typedef struct { u8 reg, data; } RegInitializer;
 
-static const RegInitializer initData[] __initdata = {
+static const RegInitializer initData[] __initconst = {
 	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
 	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
 	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 2c8016a..911a27c 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -512,7 +512,7 @@ static const struct ide_dma_ops ali_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info ali15x3_chipset __devinitdata = {
+static const struct ide_port_info ali15x3_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
index 3747b25..56fc995 100644
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -223,7 +223,7 @@ static const struct ide_port_ops amd_port_ops = {
 		.udma_mask	= udma,					\
 	}
 
-static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
+static const struct ide_port_info amd74xx_chipsets[] __devinitconst = {
 	/* 0: AMD7401 */	DECLARE_AMD_DEV(0x00, ATA_UDMA2),
 	/* 1: AMD7409 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA4),
 	/* 2: AMD7411/7441 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
index 000a78e..8239419 100644
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -208,7 +208,7 @@ static const struct ide_port_ops at91_ide_port_ops = {
 	.set_pio_mode	= at91_ide_set_pio_mode,
 };
 
-static const struct ide_port_info at91_ide_port_info __initdata = {
+static const struct ide_port_info at91_ide_port_info __initconst = {
 	.port_ops	= &at91_ide_port_ops,
 	.tp_ops		= &at91_ide_tp_ops,
 	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
diff --git a/drivers/ide/atiixp.c b/drivers/ide/atiixp.c
index 15f0ead..cb43480 100644
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -139,7 +139,7 @@ static const struct ide_port_ops atiixp_port_ops = {
 	.cable_detect		= atiixp_cable_detect,
 };
 
-static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
+static const struct ide_port_info atiixp_pci_info[] __devinitconst = {
 	{	/* 0: IXP200/300/400/700 */
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index cb10201..b30a5c1 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -684,7 +684,7 @@ static int pci_conf2(void)
 	return 0;
 }
 
-static const struct ide_port_info cmd640_port_info __initdata = {
+static const struct ide_port_info cmd640_port_info __initconst = {
 	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index 5f80312..d1fc438 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -327,7 +327,7 @@ static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
+static const struct ide_port_info cmd64x_chipsets[] __devinitconst = {
 	{	/* 0: CMD643 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
diff --git a/drivers/ide/cs5520.c b/drivers/ide/cs5520.c
index 2c1e5f7..1444762 100644
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -94,7 +94,7 @@ static const struct ide_port_ops cs5520_port_ops = {
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-static const struct ide_port_info cyrix_chipset __devinitdata = {
+static const struct ide_port_info cyrix_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { { 0x60, 0x01, 0x01 }, { 0x60, 0x02, 0x02 } },
 	.port_ops	= &cs5520_port_ops,
diff --git a/drivers/ide/cs5530.c b/drivers/ide/cs5530.c
index 4dc4eb9..49b40ad 100644
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -245,7 +245,7 @@ static const struct ide_port_ops cs5530_port_ops = {
 	.udma_filter		= cs5530_udma_filter,
 };
 
-static const struct ide_port_info cs5530_chipset __devinitdata = {
+static const struct ide_port_info cs5530_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
diff --git a/drivers/ide/cs5535.c b/drivers/ide/cs5535.c
index 5059faf..18d4c85 100644
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -170,7 +170,7 @@ static const struct ide_port_ops cs5535_port_ops = {
 	.cable_detect		= cs5535_cable_detect,
 };
 
-static const struct ide_port_info cs5535_chipset __devinitdata = {
+static const struct ide_port_info cs5535_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &cs5535_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
diff --git a/drivers/ide/cy82c693.c b/drivers/ide/cy82c693.c
index 67cbcfa..37ea151 100644
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -163,7 +163,7 @@ static const struct ide_port_ops cy82c693_port_ops = {
 	.set_dma_mode		= cy82c693_set_dma_mode,
 };
 
-static const struct ide_port_info cy82c693_chipset __devinitdata = {
+static const struct ide_port_info cy82c693_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
index 6929f7f..0b0eddc 100644
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -91,7 +91,7 @@ static const struct ide_port_ops dtc2278_port_ops = {
 	.set_pio_mode		= dtc2278_set_pio_mode,
 };
 
-static const struct ide_port_info dtc2278_port_info __initdata = {
+static const struct ide_port_info dtc2278_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_dtc2278,
 	.port_ops		= &dtc2278_port_ops,
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 58c51cd..4aec3b8 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -443,7 +443,7 @@ static struct hpt_timings hpt37x_timings = {
 	}
 };
 
-static const struct hpt_info hpt36x __devinitdata = {
+static const struct hpt_info hpt36x __devinitconst = {
 	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
@@ -451,7 +451,7 @@ static const struct hpt_info hpt36x __devinitdata = {
 	.timings	= &hpt36x_timings
 };
 
-static const struct hpt_info hpt370 __devinitdata = {
+static const struct hpt_info hpt370 __devinitconst = {
 	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -459,7 +459,7 @@ static const struct hpt_info hpt370 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt370a __devinitdata = {
+static const struct hpt_info hpt370a __devinitconst = {
 	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -467,7 +467,7 @@ static const struct hpt_info hpt370a __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt374 __devinitdata = {
+static const struct hpt_info hpt374 __devinitconst = {
 	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
@@ -475,7 +475,7 @@ static const struct hpt_info hpt374 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372 __devinitdata = {
+static const struct hpt_info hpt372 __devinitconst = {
 	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -483,7 +483,7 @@ static const struct hpt_info hpt372 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372a __devinitdata = {
+static const struct hpt_info hpt372a __devinitconst = {
 	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -491,7 +491,7 @@ static const struct hpt_info hpt372a __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302 __devinitdata = {
+static const struct hpt_info hpt302 __devinitconst = {
 	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -499,7 +499,7 @@ static const struct hpt_info hpt302 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371 __devinitdata = {
+static const struct hpt_info hpt371 __devinitconst = {
 	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -507,7 +507,7 @@ static const struct hpt_info hpt371 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372n __devinitdata = {
+static const struct hpt_info hpt372n __devinitconst = {
 	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -515,7 +515,7 @@ static const struct hpt_info hpt372n __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302n __devinitdata = {
+static const struct hpt_info hpt302n __devinitconst = {
 	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -523,7 +523,7 @@ static const struct hpt_info hpt302n __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371n __devinitdata = {
+static const struct hpt_info hpt371n __devinitconst = {
 	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -1361,7 +1361,7 @@ static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
+static const struct ide_port_info hpt366_chipsets[] __devinitconst = {
 	{	/* 0: HPT36x */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index 808bcdc..73b08b1 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -341,7 +341,7 @@ static const struct ide_port_ops ht6560b_port_ops = {
 	.set_pio_mode		= ht6560b_set_pio_mode,
 };
 
-static const struct ide_port_info ht6560b_port_info __initdata = {
+static const struct ide_port_info ht6560b_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
 	.tp_ops 		= &ht6560b_tp_ops,
diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 4a697a2..ff6eaa0 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -453,7 +453,7 @@ err_free:
 	return ret;
 }
 
-static const struct ide_port_info icside_v6_port_info __initdata = {
+static const struct ide_port_info icside_v6_port_info __initconst = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index a743e68..1cfd674 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -53,7 +53,7 @@ static const struct ide_port_ops netcell_port_ops = {
 		.udma_mask	= ATA_UDMA6, \
 	}
 
-static const struct ide_port_info generic_chipsets[] __devinitdata = {
+static const struct ide_port_info generic_chipsets[] __devinitconst = {
 	/*  0: Unknown */
 	DECLARE_GENERIC_PCI_DEV(0),
 
diff --git a/drivers/ide/it8172.c b/drivers/ide/it8172.c
index 560e66d..d5dd180 100644
--- a/drivers/ide/it8172.c
+++ b/drivers/ide/it8172.c
@@ -115,7 +115,7 @@ static const struct ide_port_ops it8172_port_ops = {
 	.set_dma_mode	= it8172_set_dma_mode,
 };
 
-static const struct ide_port_info it8172_port_info __devinitdata = {
+static const struct ide_port_info it8172_port_info __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &it8172_port_ops,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x00, 0x00, 0x00} },
diff --git a/drivers/ide/it8213.c b/drivers/ide/it8213.c
index 46816ba..1847aeb 100644
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -156,7 +156,7 @@ static const struct ide_port_ops it8213_port_ops = {
 	.cable_detect		= it8213_cable_detect,
 };
 
-static const struct ide_port_info it8213_chipset __devinitdata = {
+static const struct ide_port_info it8213_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80} },
 	.port_ops	= &it8213_port_ops,
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 2e3169f..c5611db 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -630,7 +630,7 @@ static const struct ide_port_ops it821x_port_ops = {
 	.cable_detect		= it821x_cable_detect,
 };
 
-static const struct ide_port_info it821x_chipset __devinitdata = {
+static const struct ide_port_info it821x_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_it821x,
 	.init_hwif	= init_hwif_it821x,
diff --git a/drivers/ide/jmicron.c b/drivers/ide/jmicron.c
index 74c2c4a..efddd7d 100644
--- a/drivers/ide/jmicron.c
+++ b/drivers/ide/jmicron.c
@@ -102,7 +102,7 @@ static const struct ide_port_ops jmicron_port_ops = {
 	.cable_detect		= jmicron_cable_detect,
 };
 
-static const struct ide_port_info jmicron_chipset __devinitdata = {
+static const struct ide_port_info jmicron_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.port_ops	= &jmicron_port_ops,
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 95327a2..73f78d8 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -293,7 +293,7 @@ static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
 
-static const struct ide_port_info ns87415_chipset __devinitdata = {
+static const struct ide_port_info ns87415_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_ns87415,
 	.tp_ops 	= &ns87415_tp_ops,
diff --git a/drivers/ide/opti621.c b/drivers/ide/opti621.c
index 1a53a4c..39edc66 100644
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -131,7 +131,7 @@ static const struct ide_port_ops opti621_port_ops = {
 	.set_pio_mode		= opti621_set_pio_mode,
 };
 
-static const struct ide_port_info opti621_chipset __devinitdata = {
+static const struct ide_port_info opti621_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 	.port_ops	= &opti621_port_ops,
diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index 9546fe2..2e5ceb6 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -465,7 +465,7 @@ static const struct ide_port_ops pdcnew_port_ops = {
 		.udma_mask	= udma, \
 	}
 
-static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
+static const struct ide_port_info pdcnew_chipsets[] __devinitconst = {
 	/* 0: PDC202{68,70} */		DECLARE_PDCNEW_DEV(ATA_UDMA5),
 	/* 1: PDC202{69,71,75,76,77} */	DECLARE_PDCNEW_DEV(ATA_UDMA6),
 };
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 3a35ec6..5634510 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -270,7 +270,7 @@ static const struct ide_dma_ops pdc2026x_dma_ops = {
 		.max_sectors	= sectors, \
 	}
 
-static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
+static const struct ide_port_info pdc202xx_chipsets[] __devinitconst = {
 	{	/* 0: PDC20246 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_pdc202xx,
diff --git a/drivers/ide/piix.c b/drivers/ide/piix.c
index b59d04c..368c2a7 100644
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -344,7 +344,7 @@ static const struct ide_port_ops ich_port_ops = {
 		.udma_mask	= udma, \
 	}
 
-static const struct ide_port_info piix_pci_info[] __devinitdata = {
+static const struct ide_port_info piix_pci_info[] __devinitconst = {
 	/* 0: MPIIX */
 	{	/*
 		 * MPIIX actually has only a single IDE channel mapped to
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 3f0244f..68ace51 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -336,7 +336,7 @@ static const struct ide_port_ops qd6580_port_ops = {
 	.set_pio_mode		= qd6580_set_pio_mode,
 };
 
-static const struct ide_port_info qd65xx_port_info __initdata = {
+static const struct ide_port_info qd65xx_port_info __initconst = {
 	.name			= DRV_NAME,
 	.tp_ops 		= &qd65xx_tp_ops,
 	.chipset		= ide_qd65xx,
diff --git a/drivers/ide/rz1000.c b/drivers/ide/rz1000.c
index a6414a8..c04173e 100644
--- a/drivers/ide/rz1000.c
+++ b/drivers/ide/rz1000.c
@@ -38,7 +38,7 @@ static int __devinit rz1000_disable_readahead(struct pci_dev *dev)
 	}
 }
 
-static const struct ide_port_info rz1000_chipset __devinitdata = {
+static const struct ide_port_info rz1000_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.host_flags	= IDE_HFLAG_NO_DMA,
 };
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index 356b9b5..d4758eb 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -291,7 +291,7 @@ static const struct ide_dma_ops sc1200_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info sc1200_chipset __devinitdata = {
+static const struct ide_port_info sc1200_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &sc1200_port_ops,
 	.dma_ops	= &sc1200_dma_ops,
diff --git a/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
index b7f5b0c..9701038 100644
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -811,7 +811,7 @@ static const struct ide_dma_ops scc_dma_ops = {
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
-static const struct ide_port_info scc_chipset __devinitdata = {
+static const struct ide_port_info scc_chipset __devinitconst = {
 	.name		= "sccIDE",
 	.init_iops	= init_iops_scc,
 	.init_dma	= scc_init_dma,
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index 35fb8da..24d72ef 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -337,7 +337,7 @@ static const struct ide_port_ops svwks_port_ops = {
 	.cable_detect		= svwks_cable_detect,
 };
 
-static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
+static const struct ide_port_info serverworks_chipsets[] __devinitconst = {
 	{	/* 0: OSB4 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
diff --git a/drivers/ide/siimage.c b/drivers/ide/siimage.c
index ddeda44..46f7e30 100644
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -719,7 +719,7 @@ static const struct ide_dma_ops sil_dma_ops = {
 		.udma_mask	= ATA_UDMA6,		\
 	}
 
-static const struct ide_port_info siimage_chipsets[] __devinitdata = {
+static const struct ide_port_info siimage_chipsets[] __devinitconst = {
 	/* 0: SiI680 */  DECLARE_SII_DEV(&sil_pata_port_ops),
 	/* 1: SiI3112 */ DECLARE_SII_DEV(&sil_sata_port_ops)
 };
diff --git a/drivers/ide/sis5513.c b/drivers/ide/sis5513.c
index 4a00225..09e61b4 100644
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -563,7 +563,7 @@ static const struct ide_port_ops sis_ata133_port_ops = {
 	.cable_detect		= sis_cable_detect,
 };
 
-static const struct ide_port_info sis5513_chipset __devinitdata = {
+static const struct ide_port_info sis5513_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
diff --git a/drivers/ide/sl82c105.c b/drivers/ide/sl82c105.c
index f21dc2a..d051cd2 100644
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -299,7 +299,7 @@ static const struct ide_dma_ops sl82c105_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info sl82c105_chipset __devinitdata = {
+static const struct ide_port_info sl82c105_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
diff --git a/drivers/ide/slc90e66.c b/drivers/ide/slc90e66.c
index 864ffe0..863a5e9 100644
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -132,7 +132,7 @@ static const struct ide_port_ops slc90e66_port_ops = {
 	.cable_detect		= slc90e66_cable_detect,
 };
 
-static const struct ide_port_info slc90e66_chipset __devinitdata = {
+static const struct ide_port_info slc90e66_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index e444d24..ba577de 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -191,7 +191,7 @@ static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info tc86c001_chipset __devinitdata = {
+static const struct ide_port_info tc86c001_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
diff --git a/drivers/ide/triflex.c b/drivers/ide/triflex.c
index e53a1b7..d11aff7 100644
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -92,7 +92,7 @@ static const struct ide_port_ops triflex_port_ops = {
 	.set_dma_mode		= triflex_set_mode,
 };
 
-static const struct ide_port_info triflex_device __devinitdata = {
+static const struct ide_port_info triflex_device __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
 	.port_ops	= &triflex_port_ops,
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index 4b42ca0..e494a98 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -324,7 +324,7 @@ static struct ide_dma_ops trm290_dma_ops = {
 	.dma_check		= trm290_dma_check,
 };
 
-static const struct ide_port_info trm290_chipset __devinitdata = {
+static const struct ide_port_info trm290_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
 	.tp_ops 	= &trm290_tp_ops,
diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index 7002765..91d49dd 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -117,7 +117,7 @@ static const struct ide_port_ops tx4938ide_port_ops = {
 	.set_pio_mode		= tx4938ide_set_pio_mode,
 };
 
-static const struct ide_port_info tx4938ide_port_info __initdata = {
+static const struct ide_port_info tx4938ide_port_info __initconst = {
 	.port_ops		= &tx4938ide_port_ops,
 #ifdef __BIG_ENDIAN
 	.tp_ops			= &tx4938ide_tp_ops,
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 71c2319..c0ab800 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -522,7 +522,7 @@ static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info tx4939ide_port_info __initdata = {
+static const struct ide_port_info tx4939ide_port_info __initconst = {
 	.init_hwif		= tx4939ide_init_hwif,
 	.init_dma		= tx4939ide_init_dma,
 	.port_ops		= &tx4939ide_port_ops,
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 47adcd0..b3c0684 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -128,7 +128,7 @@ static const struct ide_port_ops umc8672_port_ops = {
 	.set_pio_mode		= umc_set_pio_mode,
 };
 
-static const struct ide_port_info umc8672_port_info __initdata = {
+static const struct ide_port_info umc8672_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index f46f49c..eb77678 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -403,7 +403,7 @@ static const struct ide_port_ops via_port_ops = {
 	.cable_detect		= via82cxxx_cable_detect,
 };
 
-static const struct ide_port_info via82cxxx_chipset __devinitdata = {
+static const struct ide_port_info via82cxxx_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
-- 
1.7.4.4

