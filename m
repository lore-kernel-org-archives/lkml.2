Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1DQSKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:10:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52416 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1DQSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ijRrTxo++Y9yjUlfLh0sdBItslnam3DEo5f4kNEWv9Dq3WUJPqnlyetzx4Dy9+GuQ+
         W4j4eBcaljUL2/VCNicwXzElNIEEZuTnQRqDYlBJJ8LdSzEro3gjooOgp2/GLHrHV5VQ
         GlPd+TksYgxozbFEILN8QKGkbR+p2CYiKENhs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/5 v2]Typo: Remove one to many sss's in the some comments.
Date: Sun, 17 Apr 2011 11:09:09 -0700
Message-Id: <1303063749-8282-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below is a resend due to rebasing to the current Mainline,
fixing some comments with to many sss's in the comments. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../devicetree/bindings/powerpc/nintendo/wii.txt   |    2 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +-
 arch/arm/mach-omap2/control.h                      |    2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/x86/xen/pci-swiotlb-xen.c                     |    2 +-
 drivers/acpi/acpica/utresrc.c                      |    2 +-
 drivers/acpi/video.c                               |    2 +-
 drivers/media/video/msp3400-driver.c               |    2 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/net/wan/pc300_drv.c                        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    8 ++++----
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c        |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h        |    2 +-
 drivers/scsi/constants.c                           |    2 +-
 drivers/scsi/esp_scsi.c                            |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    2 +-
 drivers/scsi/nsp32_debug.c                         |    2 +-
 drivers/scsi/pcmcia/nsp_debug.c                    |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    2 +-
 drivers/staging/bcm/Ioctl.h                        |   12 ++++++------
 drivers/staging/cxt1e1/libsbew.h                   |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    2 +-
 fs/btrfs/relocation.c                              |    2 +-
 fs/freevxfs/vxfs_inode.c                           |    2 +-
 fs/squashfs/Kconfig                                |    4 ++--
 fs/squashfs/cache.c                                |    2 +-
 include/net/genetlink.h                            |    2 +-
 include/net/netlink.h                              |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    2 +-
 32 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt b/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
index a7e155a..36afa32 100644
--- a/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
+++ b/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
@@ -127,7 +127,7 @@ Nintendo Wii device tree
    - reg : should contain the SDHCI registers location and length
    - interrupts : should contain the SDHCI interrupt
 
-1.j) The Inter-Processsor Communication (IPC) node
+1.j) The Inter-Processor Communication (IPC) node
 
   Represent the Inter-Processor Communication interface. This interface
   enables communications between the Broadway and the Starlet processors.
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c98c759..2f494b6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -55,7 +55,7 @@
 
 #include "msm_iomap-8960.h"
 
-/* Virtual addressses shared across all MSM targets. */
+/* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
 #define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
 #define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index c2804c1..a016c8b 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -236,7 +236,7 @@
 #define OMAP343X_CONTROL_WKUP_DEBOBS3 (OMAP343X_CONTROL_GENERAL_WKUP + 0x014)
 #define OMAP343X_CONTROL_WKUP_DEBOBS4 (OMAP343X_CONTROL_GENERAL_WKUP + 0x018)
 
-/* 36xx-only RTA - Retention till Accesss control registers and bits */
+/* 36xx-only RTA - Retention till Access control registers and bits */
 #define OMAP36XX_CONTROL_MEM_RTA_CTRL	0x40C
 #define OMAP36XX_RTA_DISABLE		0x0
 
diff --git a/arch/powerpc/include/asm/pte-hash64-64k.h b/arch/powerpc/include/asm/pte-hash64-64k.h
index c4490f9..59247e8 100644
--- a/arch/powerpc/include/asm/pte-hash64-64k.h
+++ b/arch/powerpc/include/asm/pte-hash64-64k.h
@@ -22,7 +22,7 @@
 #define _PAGE_HASHPTE	_PAGE_HPTE_SUB
 
 /* Note the full page bits must be in the same location as for normal
- * 4k pages as the same asssembly will be used to insert 64K pages
+ * 4k pages as the same assembly will be used to insert 64K pages
  * wether the kernel has CONFIG_PPC_64K_PAGES or not
  */
 #define _PAGE_F_SECOND  0x00008000 /* full page: hidx bits */
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 42850ee..9411747 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -142,7 +142,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 		return 0;
 
 	/*
-	 * On Book E and perhaps other processsors, singlestep is handled on
+	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
 	 * to fail, since it it locates the thread_info by masking off
 	 * the low bits of the current stack pointer.  We work around
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index bfd0632..b480d42 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -36,7 +36,7 @@ int __init pci_xen_swiotlb_detect(void)
 
 	/* If running as PV guest, either iommu=soft, or swiotlb=force will
 	 * activate this IOMMU. If running as PV privileged, activate it
-	 * irregardlesss.
+	 * irregardless.
 	 */
 	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
 	    (xen_pv_domain()))
diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index 84e0518..6ffd3a8 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("utresrc")
 #if defined(ACPI_DISASSEMBLER) || defined (ACPI_DEBUGGER)
 /*
  * Strings used to decode resource descriptors.
- * Used by both the disasssembler and the debugger resource dump routines
+ * Used by both the disassembler and the debugger resource dump routines
  */
 const char *acpi_gbl_bm_decode[] = {
 	"NotBusMaster",
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index ec574fc..db39e9e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1521,7 +1521,7 @@ static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data)
 		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_BRIGHTNESSDOWN;
 		break;
-	case ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS:	/* zero brightnesss */
+	case ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS:	/* zero brightness */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
 		acpi_bus_generate_proc_event(device, event, 0);
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index 8126622..de5d481 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -96,7 +96,7 @@ MODULE_PARM_DESC(debug, "Enable debug messages [0-3]");
 MODULE_PARM_DESC(stereo_threshold, "Sets signal threshold to activate stereo");
 MODULE_PARM_DESC(standard, "Specify audio standard: 32 = NTSC, 64 = radio, Default: Autodetect");
 MODULE_PARM_DESC(amsound, "Hardwire AM sound at 6.5Hz (France), FM can autoscan");
-MODULE_PARM_DESC(dolby, "Activates Dolby processsing");
+MODULE_PARM_DESC(dolby, "Activates Dolby processing");
 
 /* ---------------------------------------------------------------------- */
 
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index e54712b..d11fbb2 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -653,7 +653,7 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 	u16 data_reg;
 
 	do {
-		/* Reading the messsage object from the Message RAM */
+		/* Reading the message object from the Message RAM */
 		iowrite32(PCH_CMASK_RX_TX_GET, &priv->regs->ifregs[0].cmask);
 		pch_can_rw_msg_obj(&priv->regs->ifregs[0].creq, obj_num);
 
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index 872183f..d532dde 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -1800,7 +1800,7 @@ static int  ali_ircc_dma_receive_complete(struct ali_ircc_cb *self)
 	MessageCount = inb(iobase+ FIR_LSR)&0x07;
 	
 	if (MessageCount > 0)	
-		IRDA_DEBUG(0, "%s(), Messsage count = %d,\n", __func__ , MessageCount);
+		IRDA_DEBUG(0, "%s(), Message count = %d,\n", __func__ , MessageCount);
 		
 	for (i=0; i<=MessageCount; i++)
 	{
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index f875cfa..737b59f 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -1445,7 +1445,7 @@ static void falc_update_stats(pc300_t * card, int ch)
  * Description:	In the remote loopback mode the clock and data recovered
  *		from the line inputs RL1/2 or RDIP/RDIN are routed back
  *		to the line outputs XL1/2 or XDOP/XDON via the analog
- *		transmitter. As in normal mode they are processsed by
+ *		transmitter. As in normal mode they are processed by
  *		the synchronizer and then sent to the system interface.
  *----------------------------------------------------------------------------
  */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6eadf97..aa1ba5d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3329,26 +3329,26 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	else
 		cptr = AR9300_BASE_ADDR;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM accesss at Address 0x%04x\n", cptr);
+		"Trying EEPROM access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying EEPROM accesss at Address 0x%04x\n", cptr);
+		"Trying EEPROM access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	read = ar9300_read_otp;
 	cptr = AR9300_BASE_ADDR;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP accesss at Address 0x%04x\n", cptr);
+		"Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
 	cptr = AR9300_BASE_ADDR_512;
 	ath_dbg(common, ATH_DBG_EEPROM,
-		"Trying OTP accesss at Address 0x%04x\n", cptr);
+		"Trying OTP access at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 42c3fe3..87813c3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7430,7 +7430,7 @@ static int ipw_associate_network(struct ipw_priv *priv,
 		priv->assoc_request.capability &=
 		    ~cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT_TIME);
 
-	IPW_DEBUG_ASSOC("%sssocation attempt: '%s', channel %d, "
+	IPW_DEBUG_ASSOC("%ssociation attempt: '%s', channel %d, "
 			"802.11%c [%d], %s[:%s], enc=%s%s%s%c%c\n",
 			roaming ? "Rea" : "A",
 			print_ssid(ssid, priv->essid, priv->essid_len),
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
index 078ed60..232aff1 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -1,5 +1,5 @@
 /*
- * Aic7xxx SCSI host adapter firmware asssembler symbol table implementation
+ * Aic7xxx SCSI host adapter firmware assembler symbol table implementation
  *
  * Copyright (c) 1997 Justin T. Gibbs.
  * Copyright (c) 2002 Adaptec Inc.
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
index 2ba73ae..34bbcad 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -1,5 +1,5 @@
 /*
- * Aic7xxx SCSI host adapter firmware asssembler symbol table definitions
+ * Aic7xxx SCSI host adapter firmware assembler symbol table definitions
  *
  * Copyright (c) 1997 Justin T. Gibbs.
  * Copyright (c) 2002 Adaptec Inc.
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d0c8234..d0cdde5 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -34,7 +34,7 @@
 static const char * cdb_byte0_names[] = {
 /* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request Sense",
 /* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
-	    "Reasssign Blocks",
+	    "Reassign Blocks",
 /* 08-0d */ "Read(6)", NULL, "Write(6)", "Seek(6)", NULL, NULL,
 /* 0e-12 */ NULL, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
 /* 13-16 */ "Verify(6)", "Recover Buffered Data", "Mode Select(6)",
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 5755852..182831e 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1059,7 +1059,7 @@ static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
 	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
 			       2, 2, 1, ESP_CMD_DMA | ESP_CMD_TI);
 
-	/* ACK the msssage.  */
+	/* ACK the message.  */
 	scsi_esp_cmd(esp, ESP_CMD_MOK);
 
 	for (i = 0; i < ESP_RESELECT_TAG_LIMIT; i++) {
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 17d7893..8dcbf8f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4532,7 +4532,7 @@ lpfc_set_vport_symbolic_name(struct fc_vport *fc_vport)
  *
  * This function is called by the lpfc_get_cfgparam() routine to set the
  * module lpfc_log_verbose into the @phba cfg_log_verbose for use with
- * log messsage according to the module's lpfc_log_verbose parameter setting
+ * log message according to the module's lpfc_log_verbose parameter setting
  * before hba port or vport created.
  **/
 static void
diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index 2fb3fb5..58806f4 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -13,7 +13,7 @@ static const char unknown[] = "UNKNOWN";
 
 static const char * group_0_commands[] = {
 /* 00-03 */ "Test Unit Ready", "Rezero Unit", unknown, "Request Sense",
-/* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reasssign Blocks",
+/* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reassign Blocks",
 /* 08-0d */ "Read (6)", unknown, "Write (6)", "Seek (6)", unknown, unknown,
 /* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
 /* 13-16 */ unknown, "Recover Buffered Data", "Mode Select", "Reserve",
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 3c6ef64..6aa7d26 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -15,7 +15,7 @@ static const char unknown[] = "UNKNOWN";
 
 static const char * group_0_commands[] = {
 /* 00-03 */ "Test Unit Ready", "Rezero Unit", unknown, "Request Sense",
-/* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reasssign Blocks",
+/* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reassign Blocks",
 /* 08-0d */ "Read (6)", unknown, "Write (6)", "Seek (6)", unknown, unknown,
 /* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
 /* 13-16 */ unknown, "Recover Buffered Data", "Mode Select", "Reserve",
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f9d81c8..d78b58d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -19,7 +19,7 @@
  * @mbx_cmd: data pointer for mailbox in registers.
  * @mbx_sts: data pointer for mailbox out registers.
  *
- * This routine isssue mailbox commands and waits for completion.
+ * This routine issue mailbox commands and waits for completion.
  * If outCount is 0, this routine completes successfully WITHOUT waiting
  * for the mailbox command to complete.
  **/
diff --git a/drivers/staging/bcm/Ioctl.h b/drivers/staging/bcm/Ioctl.h
index f859cf1..9d41c84 100644
--- a/drivers/staging/bcm/Ioctl.h
+++ b/drivers/staging/bcm/Ioctl.h
@@ -303,14 +303,14 @@ typedef enum _SECTION_TYPE
 } SECTION_TYPE, *PSECTION_TYPE;
 
 /*
-*	This section provide the complete bitmap of the Flash.
-*	using this map lib/APP will isssue read/write command.
+	This section provide the complete bitmap of the Flash.
+	using this map lib/APP will issue read/write command.
 	Fields are defined as :
 	Bit [0] = section is present  //1:present, 0: Not present
-*      Bit [1] = section is valid  //1: valid, 0: not valid
-*      Bit [2] = Section is R/W  //0: RW, 1: RO
-*	Bit [3] = Section is Active or not 1 means Active, 0->inactive
-*      Bit [7...3] = Reserved
+	Bit [1] = section is valid  //1: valid, 0: not valid
+	Bit [2] = Section is R/W  //0: RW, 1: RO
+	Bit [3] = Section is Active or not 1 means Active, 0->inactive
+	Bit [7...3] = Reserved
 */
 
 typedef struct _FLASH2X_BITMAP
diff --git a/drivers/staging/cxt1e1/libsbew.h b/drivers/staging/cxt1e1/libsbew.h
index 5c99646..ae8f06d 100644
--- a/drivers/staging/cxt1e1/libsbew.h
+++ b/drivers/staging/cxt1e1/libsbew.h
@@ -323,7 +323,7 @@ struct sbecom_port_param
 #define CFG_CH_DINV_TX      0x02
 
 
-/* Posssible resettable chipsets/functions */
+/* Possible resettable chipsets/functions */
 #define RESET_DEV_TEMUX     1
 #define RESET_DEV_TECT3     RESET_DEV_TEMUX
 #define RESET_DEV_PLL       2
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 3c31340..177ae52 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2208,7 +2208,7 @@ struct rt_tx_blk {
 	/* Following structure used for the characteristics of a specific packet. */
 	void *pPacket;
 	u8 *pSrcBufHeader;	/* Reference to the head of sk_buff->data */
-	u8 *pSrcBufData;	/* Reference to the sk_buff->data, will change depending on the handling progresss */
+	u8 *pSrcBufData;	/* Reference to the sk_buff->data, will change depending on the handling progress */
 	u32 SrcBufLen;		/* Length of packet payload which not including Layer 2 header */
 	u8 *pExtraLlcSnapEncap;	/* NULL means no extra LLC/SNAP is required */
 	u8 HeaderBuf[128];	/* TempBuffer for TX_INFO + TX_WI + 802.11 Header + padding + AMSDU SubHeader + LLC/SNAP */
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 199a801..f340f7c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -709,7 +709,7 @@ again:
 	WARN_ON(cur->checked);
 	if (!list_empty(&cur->upper)) {
 		/*
-		 * the backref was added previously when processsing
+		 * the backref was added previously when processing
 		 * backref of type BTRFS_TREE_BLOCK_REF_KEY
 		 */
 		BUG_ON(!list_is_singular(&cur->upper));
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 2ba6719..1a43114 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -272,7 +272,7 @@ vxfs_get_fake_inode(struct super_block *sbp, struct vxfs_inode_info *vip)
  * *ip:			VFS inode
  *
  * Description:
- *  vxfs_put_fake_inode frees all data asssociated with @ip.
+ *  vxfs_put_fake_inode frees all data associated with @ip.
  */
 void
 vxfs_put_fake_inode(struct inode *ip)
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index efc309f..7797218 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -42,7 +42,7 @@ config SQUASHFS_LZO
 	select LZO_DECOMPRESS
 	help
 	  Saying Y here includes support for reading Squashfs file systems
-	  compressed with LZO compresssion.  LZO compression is mainly
+	  compressed with LZO compression.  LZO compression is mainly
 	  aimed at embedded systems with slower CPUs where the overheads
 	  of zlib are too high.
 
@@ -57,7 +57,7 @@ config SQUASHFS_XZ
 	select XZ_DEC
 	help
 	  Saying Y here includes support for reading Squashfs file systems
-	  compressed with XZ compresssion.  XZ gives better compression than
+	  compressed with XZ compression.  XZ gives better compression than
 	  the default zlib compression, at the expense of greater CPU and
 	  memory overhead.
 
diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index c37b520..4b5a3fb 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -29,7 +29,7 @@
  * plus functions layered ontop of the generic cache implementation to
  * access the metadata and fragment caches.
  *
- * To avoid out of memory and fragmentation isssues with vmalloc the cache
+ * To avoid out of memory and fragmentation issues with vmalloc the cache
  * uses sequences of kmalloced PAGE_CACHE_SIZE buffers.
  *
  * It should be noted that the cache is not used for file datablocks, these
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index b4c7c1c..d420f28 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -260,7 +260,7 @@ static inline int genlmsg_reply(struct sk_buff *skb, struct genl_info *info)
 
 /**
  * gennlmsg_data - head of message payload
- * @gnlh: genetlink messsage header
+ * @gnlh: genetlink message header
  */
 static inline void *genlmsg_data(const struct genlmsghdr *gnlh)
 {
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 8a3906a..02740a9 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -290,7 +290,7 @@ static inline int nlmsg_padlen(int payload)
 
 /**
  * nlmsg_data - head of message payload
- * @nlh: netlink messsage header
+ * @nlh: netlink message header
  */
 static inline void *nlmsg_data(const struct nlmsghdr *nlh)
 {
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 1a10dcd..6c014dd 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -333,7 +333,7 @@ static void rq_cq_reap(struct svcxprt_rdma *xprt)
 }
 
 /*
- * Processs a completion context
+ * Process a completion context
  */
 static void process_context(struct svcxprt_rdma *xprt,
 			    struct svc_rdma_op_ctxt *ctxt)
-- 
1.7.4.4

