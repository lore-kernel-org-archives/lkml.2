Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0GLPQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:16:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38619 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0GLPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:15:58 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH 2/3] trivial: fix typos concerning "address"
Date: Mon, 12 Jul 2010 17:15:45 +0200
Message-Id: <1278947746-11253-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278947746-11253-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1278947746-11253-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/networking/arcnet-hardware.txt       |    2 +-
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 arch/arm/common/it8152.c                           |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |    2 +-
 arch/arm/mach-u300/include/mach/coh901318.h        |    2 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |    2 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |    2 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |    2 +-
 arch/cris/arch-v32/lib/nand_init.S                 |    2 +-
 arch/mips/pci/pcie-octeon.c                        |    2 +-
 arch/mips/txx9/generic/pci.c                       |    2 +-
 arch/sh/mm/cache-sh5.c                             |    2 +-
 arch/sparc/kernel/traps_64.c                       |    2 +-
 arch/x86/include/asm/pgalloc.h                     |    2 +-
 drivers/edac/cell_edac.c                           |    4 ++--
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/media/video/davinci/vpif.h                 |    2 +-
 drivers/net/bnx2x_reg.h                            |    2 +-
 drivers/net/bonding/bond_3ad.c                     |    4 ++--
 drivers/net/chelsio/subr.c                         |    2 +-
 drivers/net/cxgb3/t3_hw.c                          |    2 +-
 drivers/net/e1000/e1000_main.c                     |    2 +-
 drivers/net/e1000e/phy.c                           |    2 +-
 drivers/net/eepro.c                                |    2 +-
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/skfp/h/supern_2.h                      |    2 +-
 drivers/net/tehuti.c                               |    2 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/wimax/i2400m/driver.c                  |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h               |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/pci/iova.c                                 |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aic94xx/aic94xx_reg_def.h             |    4 ++--
 drivers/spi/atmel_spi.c                            |    4 ++--
 drivers/usb/wusbcore/wa-rpipe.c                    |    2 +-
 fs/ext4/ext4.h                                     |    2 +-
 include/acpi/actbl1.h                              |    2 +-
 include/net/sctp/user.h                            |    4 ++--
 kernel/kexec.c                                     |    2 +-
 kernel/sysctl_binary.c                             |    2 +-
 kernel/trace/trace_entries.h                       |    2 +-
 net/decnet/dn_dev.c                                |    2 +-
 sound/pci/ca0106/ca0106.h                          |    2 +-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/emu10k1/p16v.h                           |    2 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 53 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/Documentation/networking/arcnet-hardware.txt b/Documentation/networking/arcnet-hardware.txt
index 731de41..0e67e9c 100644
--- a/Documentation/networking/arcnet-hardware.txt
+++ b/Documentation/networking/arcnet-hardware.txt
@@ -2884,7 +2884,7 @@ Jumpers 3-5 of jumper block SW1 select the Memory Base address.
   
 *) To enable the Boot ROM set the jumper 8 of jumper block SW3 to position ON.
 
-The jumpers 1 and 2 probably add 0x0800, 0x1000 and 0x1800 to RAM adders.
+The jumpers 1 and 2 probably add 0x0800, 0x1000 and 0x1800 to RAM address.
 
 Setting the Interrupt Line
 --------------------------
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 46d2210..2dac110 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1125,7 +1125,7 @@ supported currently at the toplevel.
                                  * an arbitrary array of bytes
                                  */
 
-  childnode@addresss {	/* define a child node named "childnode"
+  childnode@address {	/* define a child node named "childnode"
                                  * whose unit name is "childnode at
 				 * address"
                                  */
diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index 7974baa..2ee1e1c 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -236,7 +236,7 @@ static struct resource it8152_mem = {
 
 /*
  * The following functions are needed for DMA bouncing.
- * ITE8152 chip can addrees up to 64MByte, so all the devices
+ * ITE8152 chip can address up to 64MByte, so all the devices
  * connected to ITE8152 (PCI and USB) should have limited DMA window
  */
 
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
index cbf334d..d67e2f8 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -28,7 +28,7 @@
 
 /* Data type for DMA Link List Item */
 typedef struct {
-	uint32_t sar;		/* Source Adress Register.
+	uint32_t sar;		/* Source Address Register.
 				   Address must be aligned to CTLx.SRC_TR_WIDTH.             */
 	uint32_t dar;		/* Destination Address Register.
 				   Address must be aligned to CTLx.DST_TR_WIDTH.             */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
index 891cea8..f1ecf96 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
@@ -35,7 +35,7 @@ typedef struct {
 
 /* Data type representing DMA channel registers */
 typedef struct {
-	dmacHw_REG64_t ChannelSar;	/*  Source Adress Register. 64 bits (upper 32 bits are reserved)
+	dmacHw_REG64_t ChannelSar;	/*  Source Address Register. 64 bits (upper 32 bits are reserved)
 					   Address must be aligned to CTLx.SRC_TR_WIDTH.
 					 */
 	dmacHw_REG64_t ChannelDar;	/*  Destination Address Register.64 bits (upper 32 bits are reserved)
diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 193da2d..2013d2b 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -24,7 +24,7 @@
  * @src_addr: transfer source address
  * @dst_addr: transfer destination address
  * @link_addr:  physical address to next lli
- * @virt_link_addr: virtual addres of next lli (only used by pool_free)
+ * @virt_link_addr: virtual address of next lli (only used by pool_free)
  * @phy_this: physical address of current lli (only used by pool_free)
  */
 struct coh901318_lli {
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
index 9241205..f889fa5 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
@@ -1324,7 +1324,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
index 8b18b53..25b4914 100644
--- a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
+++ b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
@@ -1333,7 +1333,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf537/include/mach/defBF534.h b/arch/blackfin/mach-bf537/include/mach/defBF534.h
index cf396ea..b20edfc 100644
--- a/arch/blackfin/mach-bf537/include/mach/defBF534.h
+++ b/arch/blackfin/mach-bf537/include/mach/defBF534.h
@@ -1647,7 +1647,7 @@
 #define	SADD_LEN	0x0002	/* Slave Address Length                                                 */
 #define	STDVAL		0x0004	/* Slave Transmit Data Valid                                    */
 #define	NAK			0x0008	/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010	/* General Call Adrress Matching Enabled                */
+#define	GEN			0x0010	/* General Call Address Matching Enabled                */
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001	/* Slave Transfer Direction (Transmit/Receive*) */
diff --git a/arch/blackfin/mach-bf538/include/mach/defBF539.h b/arch/blackfin/mach-bf538/include/mach/defBF539.h
index d7061d9..182c840 100644
--- a/arch/blackfin/mach-bf538/include/mach/defBF539.h
+++ b/arch/blackfin/mach-bf538/include/mach/defBF539.h
@@ -2363,7 +2363,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length */
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid */
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call	Adrress	Matching Enabled */
+#define	GEN			0x0010		/* General Call	Address	Matching Enabled */
 
 /* TWIx_SLAVE_STAT Masks								 */
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*) */
diff --git a/arch/cris/arch-v32/lib/nand_init.S b/arch/cris/arch-v32/lib/nand_init.S
index e705f5c..d671fed 100644
--- a/arch/cris/arch-v32/lib/nand_init.S
+++ b/arch/cris/arch-v32/lib/nand_init.S
@@ -139,7 +139,7 @@ copy_nand_to_ram:
 	lsrq	8, $r4
 	move.b	$r4, [$r1]	; Row address
 	lsrq	8, $r4
-	move.b	$r4, [$r1]	; Row adddress
+	move.b	$r4, [$r1]	; Row address
 	moveq	20, $r4
 2:	bne	2b
 	subq	1, $r4
diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
index 6aa5c54..77a356e 100644
--- a/arch/mips/pci/pcie-octeon.c
+++ b/arch/mips/pci/pcie-octeon.c
@@ -891,7 +891,7 @@ static int cvmx_pcie_rc_initialize(int pcie_port)
 	mem_access_subid.s.ror = 0;
 	/* Disable Relaxed Ordering for Writes. */
 	mem_access_subid.s.row = 0;
-	/* PCIe Adddress Bits <63:34>. */
+	/* PCIe Address Bits <63:34>. */
 	mem_access_subid.s.ba = 0;
 
 	/*
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 9a0be81..96e69a0 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -107,7 +107,7 @@ int txx9_pci_mem_high __initdata;
 
 /*
  * allocate pci_controller and resources.
- * mem_base, io_base: physical addresss.  0 for auto assignment.
+ * mem_base, io_base: physical address.  0 for auto assignment.
  * mem_size and io_size means max size on auto assignment.
  * pcic must be &txx9_primary_pcic or NULL.
  */
diff --git a/arch/sh/mm/cache-sh5.c b/arch/sh/mm/cache-sh5.c
index eb4cc4e..d1bffbc 100644
--- a/arch/sh/mm/cache-sh5.c
+++ b/arch/sh/mm/cache-sh5.c
@@ -568,7 +568,7 @@ static void sh5_flush_dcache_page(void *page)
 }
 
 /*
- * Flush the range [start,end] of kernel virtual adddress space from
+ * Flush the range [start,end] of kernel virtual address space from
  * the I-cache.  The corresponding range must be purged from the
  * D-cache also because the SH-5 doesn't have cache snooping between
  * the caches.  The addresses will be visible through the superpage
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 42ad2ba..1e97709 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -622,7 +622,7 @@ static const char CHAFSR_PERR_msg[] =
 static const char CHAFSR_IERR_msg[] =
 	"Internal processor error";
 static const char CHAFSR_ISAP_msg[] =
-	"System request parity error on incoming addresss";
+	"System request parity error on incoming address";
 static const char CHAFSR_UCU_msg[] =
 	"Uncorrectable E-cache ECC error for ifetch/data";
 static const char CHAFSR_UCC_msg[] =
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 271de94..b4389a4 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -92,7 +92,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
-				  unsigned long adddress)
+				  unsigned long address)
 {
 	___pmd_free_tlb(tlb, pmd);
 }
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index c973004..db1df59 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -47,7 +47,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
-	/* TODO: Decoding of the error addresss */
+	/* TODO: Decoding of the error address */
 	edac_mc_handle_ce(mci, csrow->first_page + pfn, offset,
 			  syndrome, 0, chan, "");
 }
@@ -68,7 +68,7 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	pfn = address >> PAGE_SHIFT;
 	offset = address & ~PAGE_MASK;
 
-	/* TODO: Decoding of the error addresss */
+	/* TODO: Decoding of the error address */
 	edac_mc_handle_ue(mci, csrow->first_page + pfn, offset, 0, "");
 }
 
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 1bc72c3..21a54d0 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -1314,7 +1314,7 @@ typedef struct _GET_ENGINE_CLOCK_PARAMETERS
 typedef struct _READ_EDID_FROM_HW_I2C_DATA_PARAMETERS
 {
   USHORT    usPrescale;         //Ratio between Engine clock and I2C clock
-  USHORT    usVRAMAddress;      //Adress in Frame Buffer where to pace raw EDID
+  USHORT    usVRAMAddress;      //Address in Frame Buffer where to pace raw EDID
   USHORT    usStatus;           //When use output: lower byte EDID checksum, high byte hardware status
                                 //WHen use input:  lower byte as 'byte to read':currently limited to 128byte or 1byte
   UCHAR     ucSlaveAddr;        //Read from which slave
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 188841b..ebd5c43 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -33,7 +33,7 @@ extern spinlock_t vpif_lock;
 #define regr(reg)               readl((reg) + vpif_base)
 #define regw(value, reg)        writel(value, (reg + vpif_base))
 
-/* Register Addresss Offsets */
+/* Register Address Offsets */
 #define VPIF_PID			(0x0000)
 #define VPIF_CH0_CTRL			(0x0004)
 #define VPIF_CH1_CTRL			(0x0008)
diff --git a/drivers/net/bnx2x_reg.h b/drivers/net/bnx2x_reg.h
index a1f3bf0..d0db947 100644
--- a/drivers/net/bnx2x_reg.h
+++ b/drivers/net/bnx2x_reg.h
@@ -1442,7 +1442,7 @@
    (~misc_registers_sw_timer_cfg_4.sw_timer_cfg_4[1] ) is set */
 #define MISC_REG_SW_TIMER_RELOAD_VAL_4				 0xa2fc
 /* [RW 32] the value of the counter for sw timers1-8. there are 8 addresses
-   in this register. addres 0 - timer 1; address 1 - timer 2, ...  address 7 -
+   in this register. address 0 - timer 1; address 1 - timer 2, ...  address 7 -
    timer 8 */
 #define MISC_REG_SW_TIMER_VAL					 0xa5c0
 /* [RW 1] Set by the MCP to remember if one or more of the drivers is/are
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 822f586..03145a7 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -848,7 +848,7 @@ static int ad_lacpdu_send(struct port *port)
 	lacpdu_header = (struct lacpdu_header *)skb_put(skb, length);
 
 	memcpy(lacpdu_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback lacpdus in receive. */
 	memcpy(lacpdu_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
@@ -890,7 +890,7 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker)
 	marker_header = (struct bond_marker_header *)skb_put(skb, length);
 
 	memcpy(marker_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback MARKERs in receive. */
 	memcpy(marker_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	marker_header->hdr.h_proto = PKT_TYPE_LACPDU;
diff --git a/drivers/net/chelsio/subr.c b/drivers/net/chelsio/subr.c
index 53bde15..ed06fea 100644
--- a/drivers/net/chelsio/subr.c
+++ b/drivers/net/chelsio/subr.c
@@ -561,7 +561,7 @@ struct chelsio_vpd_t {
 #define EEPROM_MAX_POLL   4
 
 /*
- * Read SEEPROM. A zero is written to the flag register when the addres is
+ * Read SEEPROM. A zero is written to the flag register when the address is
  * written to the Control register. The hardware device will set the flag to a
  * one when 4B have been transferred to the Data register.
  */
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 95a8ba0..a591fed 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -605,7 +605,7 @@ struct t3_vpd {
  *
  *	Read a 32-bit word from a location in VPD EEPROM using the card's PCI
  *	VPD ROM capability.  A zero is written to the flag bit when the
- *	addres is written to the control register.  The hardware device will
+ *	address is written to the control register.  The hardware device will
  *	set the flag to 1 when 4 bytes have been read into the data register.
  */
 int t3_seeprom_read(struct adapter *adapter, u32 addr, __le32 *data)
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index ebdea08..fd8eaab 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2150,7 +2150,7 @@ static void e1000_set_rx_mode(struct net_device *netdev)
 	 * addresses take precedence to avoid disabling unicast filtering
 	 * when possible.
 	 *
-	 * RAR 0 is used for the station MAC adddress
+	 * RAR 0 is used for the station MAC address
 	 * if there are not 14 addresses, go ahead and clear the filters
 	 */
 	i = 1;
diff --git a/drivers/net/e1000e/phy.c b/drivers/net/e1000e/phy.c
index b4ac82d..7bcb356 100644
--- a/drivers/net/e1000e/phy.c
+++ b/drivers/net/e1000e/phy.c
@@ -2973,7 +2973,7 @@ s32 e1000_write_phy_reg_hv_locked(struct e1000_hw *hw, u32 offset, u16 data)
 }
 
 /**
- *  e1000_get_phy_addr_for_hv_page - Get PHY adrress based on page
+ *  e1000_get_phy_addr_for_hv_page - Get PHY address based on page
  *  @page: page to be accessed
  **/
 static u32 e1000_get_phy_addr_for_hv_page(u32 page)
diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 8d97f16..9be9df6 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -1760,7 +1760,7 @@ module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
 module_param_array(mem, int, NULL, 0);
 module_param(autodetect, int, 0);
-MODULE_PARM_DESC(io, "EtherExpress Pro/10 I/O base addres(es)");
+MODULE_PARM_DESC(io, "EtherExpress Pro/10 I/O base address(es)");
 MODULE_PARM_DESC(irq, "EtherExpress Pro/10 IRQ number(s)");
 MODULE_PARM_DESC(mem, "EtherExpress Pro/10 Rx buffer size(es) in kB (3-29)");
 MODULE_PARM_DESC(autodetect, "EtherExpress Pro/10 force board(s) detection (0-1)");
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 315eb4c..04160c9 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -203,7 +203,7 @@ static int temac_dma_bd_init(struct net_device *ndev)
 
 	lp->rx_skb = kzalloc(sizeof(*lp->rx_skb) * RX_BD_NUM, GFP_KERNEL);
 	/* allocate the tx and rx ring buffer descriptors. */
-	/* returns a virtual addres and a physical address. */
+	/* returns a virtual address and a physical address. */
 	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
 					 sizeof(*lp->tx_bd_v) * TX_BD_NUM,
 					 &lp->tx_bd_p, GFP_KERNEL);
diff --git a/drivers/net/skfp/h/supern_2.h b/drivers/net/skfp/h/supern_2.h
index 5ba0b83..5607fb3 100644
--- a/drivers/net/skfp/h/supern_2.h
+++ b/drivers/net/skfp/h/supern_2.h
@@ -345,7 +345,7 @@ struct tx_queue {
 #define	FM_LTDPA1	0x79		/* r/w Last Trans desc ptr for A1 qu. */
 /* 0x80-0x9a	PLCS registers of built-in PLCS  (Supernet 3 only) */
 
-/* Supernet 3: Adderss Filter Registers */
+/* Supernet 3: Address Filter Registers */
 #define	FM_AFCMD	0xb0		/* r/w Address Filter Command Reg */
 #define	FM_AFSTAT	0xb2		/* r/w Address Filter Status Reg */
 #define	FM_AFBIST	0xb4		/* r/w Address Filter BIST signature */
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 737df60..90e5048 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -821,7 +821,7 @@ static void bdx_setmulti(struct net_device *ndev)
 		}
 
 		/* use PMF to accept first MAC_MCST_NUM (15) addresses */
-		/* TBD: sort addreses and write them in ascending order
+		/* TBD: sort addresses and write them in ascending order
 		 * into RX_MAC_MCST regs. we skip this phase now and accept ALL
 		 * multicast frames throu IMF */
 		/* accept the rest of addresses throu IMF */
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6ad6fe7..6d3413d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1297,7 +1297,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case SIOCGIFHWADDR:
-		/* Get hw addres */
+		/* Get hw address */
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
 		ifr.ifr_hwaddr.sa_family = tun->dev->type;
 		if (copy_to_user(argp, &ifr, ifreq_len))
diff --git a/drivers/net/vxge/vxge-traffic.h b/drivers/net/vxge/vxge-traffic.h
index c252f3d..f115a4d 100644
--- a/drivers/net/vxge/vxge-traffic.h
+++ b/drivers/net/vxge/vxge-traffic.h
@@ -1695,7 +1695,7 @@ struct vxge_hw_device_stats_sw_err {
  * struct vxge_hw_device_stats - Contains HW per-device statistics,
  * including hw.
  * @devh: HW device handle.
- * @dma_addr: DMA addres of the %hw_info. Given to device to fill-in the stats.
+ * @dma_addr: DMA address of the %hw_info. Given to device to fill-in the stats.
  * @hw_info_dmah: DMA handle used to map hw statistics onto the device memory
  *                space.
  * @hw_info_dma_acch: One more DMA handle used subsequently to free the
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 9c8b78d..27c3200 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -280,7 +280,7 @@ int i2400m_check_mac_addr(struct i2400m *i2400m)
 			result);
 		goto error;
 	}
-	/* Extract MAC addresss */
+	/* Extract MAC address */
 	ddi = (void *) skb->data;
 	BUILD_BUG_ON(ETH_ALEN != sizeof(ddi->mac_address));
 	d_printf(2, dev, "GET DEVICE INFO: mac addr %pM\n",
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 55b4ac6..5246e56 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1064,7 +1064,7 @@
 /*
  * EEPROM command register
  */
-#define AR5K_EEPROM_CMD		0x6008			/* Register Addres */
+#define AR5K_EEPROM_CMD		0x6008			/* Register Address */
 #define AR5K_EEPROM_CMD_READ	0x00000001	/* EEPROM read */
 #define AR5K_EEPROM_CMD_WRITE	0x00000002	/* EEPROM write */
 #define AR5K_EEPROM_CMD_RESET	0x00000004	/* EEPROM reset */
@@ -1084,7 +1084,7 @@
 /*
  * EEPROM config register
  */
-#define AR5K_EEPROM_CFG			0x6010			/* Register Addres */
+#define AR5K_EEPROM_CFG			0x6010			/* Register Address */
 #define AR5K_EEPROM_CFG_SIZE		0x00000003		/* Size determination override */
 #define AR5K_EEPROM_CFG_SIZE_AUTO	0
 #define AR5K_EEPROM_CFG_SIZE_4KBIT	1
@@ -1126,7 +1126,7 @@
  * Second station id register (Upper 16 bits of MAC address + PCU settings)
  */
 #define AR5K_STA_ID1			0x8004			/* Register Address */
-#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC addres */
+#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC address */
 #define AR5K_STA_ID1_AP			0x00010000	/* Set AP mode */
 #define AR5K_STA_ID1_ADHOC		0x00020000	/* Set Ad-Hoc mode */
 #define AR5K_STA_ID1_PWR_SV		0x00040000	/* Power save reporting */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 83a2636..3774230 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -104,7 +104,7 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 	/*
 	 * XXX: The MAC address in the command buffer is often changed from
 	 * the original sent to the device. That is, the MAC address
-	 * written to the command buffer often is not the same MAC adress
+	 * written to the command buffer often is not the same MAC address
 	 * read from the command buffer when the command returns. This
 	 * issue has not yet been resolved and this debugging is left to
 	 * observe the problem.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index abbd857..c848fc0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -278,7 +278,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	memcpy(&intf->mac, vif->addr, ETH_ALEN);
 
 	/*
-	 * The MAC adddress must be configured after the device
+	 * The MAC address must be configured after the device
 	 * has been initialized. Otherwise the device can reset
 	 * the MAC registers.
 	 */
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 376c6b9..a3e909d 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -209,7 +209,7 @@ static inline void wl3501_switch_page(struct wl3501_card *this, u8 page)
 }
 
 /*
- * Get Ethernet MAC addresss.
+ * Get Ethernet MAC address.
  *
  * WARNING: We switch to FPAGE0 and switc back again.
  *          Making sure there is no other WL function beening called by ISR.
diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index 7914951..693ea16 100644
--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -364,7 +364,7 @@ __adjust_overlap_range(struct iova *iova,
  * reserve_iova - reserves an iova in the given range
  * @iovad: - iova domain pointer
  * @pfn_lo: - lower page frame address
- * @pfn_hi:- higher pfn adderss
+ * @pfn_hi:- higher pfn address
  * This function allocates reserves the address range from pfn_lo to pfn_hi so
  * that this address is not dished out as part of alloc_iova.
  */
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index dbbc601..61a6182 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -416,7 +416,7 @@ static u8 orc_load_firmware(struct orc_host * host)
 	/* Go back and check they match */
 
 	outb(PRGMRST | DOWNLOAD, host->base + ORC_RISCCTL);	/* Reset program count 0 */
-	bios_addr -= 0x1000;	/* Reset the BIOS adddress      */
+	bios_addr -= 0x1000;	/* Reset the BIOS address      */
 	for (i = 0, data32_ptr = (u8 *) & data32;	/* Check the code       */
 	     i < 0x1000;	/* Firmware code size = 4K      */
 	     i++, bios_addr++) {
diff --git a/drivers/scsi/aic94xx/aic94xx_reg_def.h b/drivers/scsi/aic94xx/aic94xx_reg_def.h
index 28aaf34..40273a7 100644
--- a/drivers/scsi/aic94xx/aic94xx_reg_def.h
+++ b/drivers/scsi/aic94xx/aic94xx_reg_def.h
@@ -1689,7 +1689,7 @@
 #define		PHY_START_CAL		0x01
 
 /*
- * HST_PCIX2 Registers, Addresss Range: (0x00-0xFC)
+ * HST_PCIX2 Registers, Address Range: (0x00-0xFC)
  */
 #define PCIX_REG_BASE_ADR		0xB8040000
 
@@ -1802,7 +1802,7 @@
 #define PCIC_TP_CTRL	0xFC
 
 /*
- * EXSI Registers, Addresss Range: (0x00-0xFC)
+ * EXSI Registers, Address Range: (0x00-0xFC)
  */
 #define EXSI_REG_BASE_ADR		REG_BASE_ADDR_EXSI
 
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index c4e0442..09ee7dd 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -341,9 +341,9 @@ static void atmel_spi_next_message(struct spi_master *master)
 /*
  * For DMA, tx_buf/tx_dma have the same relationship as rx_buf/rx_dma:
  *  - The buffer is either valid for CPU access, else NULL
- *  - If the buffer is valid, so is its DMA addresss
+ *  - If the buffer is valid, so is its DMA address
  *
- * This driver manages the dma addresss unless message->is_dma_mapped.
+ * This driver manages the dma address unless message->is_dma_mapped.
  */
 static int
 atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index c7b1d81..fad0daf 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -49,7 +49,7 @@
  *
  *  USB Stack port number    4 (1 based)
  *  WUSB code port index     3 (0 based)
- *  USB Addresss             5 (2 based -- 0 is for default, 1 for root hub)
+ *  USB Address              5 (2 based -- 0 is for default, 1 for root hub)
  *
  *  Now, because we don't use the concept as default address exactly
  *  like the (wired) USB code does, we need to kind of skip it. So we
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..07952d3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -548,7 +548,7 @@ struct ext4_mount_options {
 #endif
 };
 
-/* Max physical block we can addres w/o extents */
+/* Max physical block we can address w/o extents */
 #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
 
 /*
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index c637b75..cd77aa7 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -119,7 +119,7 @@ struct acpi_whea_header {
 struct acpi_table_bert {
 	struct acpi_table_header header;	/* Common ACPI table header */
 	u32 region_length;	/* Length of the boot error region */
-	u64 address;		/* Physical addresss of the error region */
+	u64 address;		/* Physical address of the error region */
 };
 
 /* Boot Error Region (not a subtable, pointed to by Address field above) */
diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 2b2769c..2a128c8 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -99,8 +99,8 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_SOCKOPT_PEELOFF	102	/* peel off association. */
 /* Options 104-106 are deprecated and removed. Do not use this space */
 #define SCTP_SOCKOPT_CONNECTX_OLD	107	/* CONNECTX old requests. */
-#define SCTP_GET_PEER_ADDRS	108		/* Get all peer addresss. */
-#define SCTP_GET_LOCAL_ADDRS	109		/* Get all local addresss. */
+#define SCTP_GET_PEER_ADDRS	108		/* Get all peer address. */
+#define SCTP_GET_LOCAL_ADDRS	109		/* Get all local address. */
 #define SCTP_SOCKOPT_CONNECTX	110		/* CONNECTX requests. */
 #define SCTP_SOCKOPT_CONNECTX3	111	/* CONNECTX requests (updated) */
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 474a847..a68068c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -161,7 +161,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	 * just verifies it is an address we can use.
 	 *
 	 * Since the kernel does everything in page size chunks ensure
-	 * the destination addreses are page aligned.  Too many
+	 * the destination addresses are page aligned.  Too many
 	 * special cases crop of when we don't do this.  The most
 	 * insidious is getting overlapping destination addresses
 	 * simply because addresses are changed to page size
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..d9c5fe4 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1193,7 +1193,7 @@ static ssize_t bin_dn_node_address(struct file *file,
 
 		buf[result] = '\0';
 
-		/* Convert the decnet addresss to binary */
+		/* Convert the decnet address to binary */
 		result = -EIO;
 		nodep = strchr(buf, '.') + 1;
 		if (!nodep)
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index dc008c1..c9b8e8a 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -53,7 +53,7 @@
  */
 
 /*
- * Function trace entry - function address and parent function addres:
+ * Function trace entry - function address and parent function address:
  */
 FTRACE_ENTRY(function, ftrace_entry,
 
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 4c409b4..9b73e0b 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -1112,7 +1112,7 @@ static struct dn_dev *dn_dev_create(struct net_device *dev, int *err)
 /*
  * This processes a device up event. We only start up
  * the loopback device & ethernet devices with correct
- * MAC addreses automatically. Others must be started
+ * MAC addresses automatically. Others must be started
  * specifically.
  *
  * FIXME: How should we configure the loopback address ? If we could dispense
diff --git a/sound/pci/ca0106/ca0106.h b/sound/pci/ca0106/ca0106.h
index 14b8d9a..afee506 100644
--- a/sound/pci/ca0106/ca0106.h
+++ b/sound/pci/ca0106/ca0106.h
@@ -188,7 +188,7 @@
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
 						/* PTR[5:0], Default: 0x0 */
 #define PLAYBACK_UNKNOWN3	0x03		/* Not used ?? */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 						/* DMA[31:0], Default: 0x0 */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size. win2000 uses 0x04000000 */
 						/* SIZE[31:16], Default: 0x0 */
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index df47f73..0c701e4 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -114,7 +114,7 @@ MODULE_PARM_DESC(enable, "Enable the EMU10K1X soundcard.");
 						 */
 #define PLAYBACK_LIST_SIZE	0x01		/* Size of list in bytes << 16. E.g. 8 periods -> 0x00380000  */
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size */
 #define PLAYBACK_POINTER	0x06		/* Playback period pointer. Sample currently in DAC */
 #define PLAYBACK_UNKNOWN1       0x07
diff --git a/sound/pci/emu10k1/p16v.h b/sound/pci/emu10k1/p16v.h
index 1532149..00f4817 100644
--- a/sound/pci/emu10k1/p16v.h
+++ b/sound/pci/emu10k1/p16v.h
@@ -96,7 +96,7 @@
 #define PLAYBACK_LIST_SIZE	0x01		/* Size of list in bytes << 16. E.g. 8 periods -> 0x00380000  */
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
 #define PLAYBACK_UNKNOWN3	0x03		/* Not used */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size. win2000 uses 0x04000000 */
 #define PLAYBACK_POINTER	0x06		/* Playback period pointer. Used with PLAYBACK_LIST_PTR to determine buffer position currently in DAC */
 #define PLAYBACK_FIFO_END_ADDRESS	0x07		/* Playback FIFO end address */
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 23a58f0..7c17f45 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -220,7 +220,7 @@ MODULE_PARM_DESC(joystick, "Enable joystick.");
 #define	RINGB_EN_2CODEC		0x0020
 #define RINGB_SING_BIT_DUAL	0x0040
 
-/* ****Port Adresses**** */
+/* ****Port Addresses**** */
 
 /*   Write & Read */
 #define ESM_INDEX		0x02
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 547b713..541f3c0 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -550,7 +550,7 @@ static inline int HDSPM_bit2freq(int n)
 	return bit2freq_tab[n];
 }
 
-/* Write/read to/from HDSPM with Adresses in Bytes
+/* Write/read to/from HDSPM with Addresses in Bytes
    not words but only 32Bit writes are allowed */
 
 static inline void hdspm_write(struct hdspm * hdspm, unsigned int reg,
-- 
1.7.1

