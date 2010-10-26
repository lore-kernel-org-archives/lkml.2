Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0JZUCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:02:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39451 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/22] trivial: fix typos concerning "command"
Date: Tue, 26 Oct 2010 21:57:03 +0200
Message-Id: <1288123039-22368-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 arch/h8300/Kconfig.debug                 |    2 +-
 arch/x86/kernel/head_32.S                |    2 +-
 drivers/atm/idt77252.h                   |    2 +-
 drivers/message/fusion/lsi/mpi_log_sas.h |    2 +-
 drivers/message/fusion/mptbase.c         |    2 +-
 drivers/mmc/card/block.c                 |    2 +-
 drivers/mmc/host/au1xmmc.c               |    2 +-
 drivers/s390/net/lcs.c                   |    2 +-
 drivers/scsi/libfc/fc_fcp.c              |    2 +-
 drivers/scsi/megaraid.h                  |    2 +-
 include/scsi/fc/fc_fcp.h                 |    4 ++--
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/h8300/Kconfig.debug b/arch/h8300/Kconfig.debug
index ee671c3..e8d1b23 100644
--- a/arch/h8300/Kconfig.debug
+++ b/arch/h8300/Kconfig.debug
@@ -48,7 +48,7 @@ config DEFAULT_CMDLINE
 	  builtin kernel commandline enabled.
 
 config KERNEL_COMMAND
-	string "Buildin commmand string"
+	string "Buildin command string"
 	depends on DEFAULT_CMDLINE
 	help
 	  builtin kernel commandline strings.
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index bcece91..8e09aa3 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -124,7 +124,7 @@ ENTRY(startup_32)
 	movsl
 	movl pa(boot_params) + NEW_CL_POINTER,%esi
 	andl %esi,%esi
-	jz 1f			# No comand line
+	jz 1f			# No command line
 	movl $pa(boot_command_line),%edi
 	movl $(COMMAND_LINE_SIZE/4),%ecx
 	rep
diff --git a/drivers/atm/idt77252.h b/drivers/atm/idt77252.h
index 5042bb2..f53a43a 100644
--- a/drivers/atm/idt77252.h
+++ b/drivers/atm/idt77252.h
@@ -572,7 +572,7 @@ struct idt77252_dev
 #define SAR_STAT_TSQF       0x00001000 /* Transmit Status Queue full      */
 #define SAR_STAT_TMROF      0x00000800 /* Timer overflow                  */
 #define SAR_STAT_PHYI       0x00000400 /* PHY device Interrupt flag       */
-#define SAR_STAT_CMDBZ      0x00000200 /* ABR SAR Comand Busy Flag        */
+#define SAR_STAT_CMDBZ      0x00000200 /* ABR SAR Command Busy Flag       */
 #define SAR_STAT_FBQ3A      0x00000100 /* Free Buffer Queue 3 Attention   */
 #define SAR_STAT_FBQ2A      0x00000080 /* Free Buffer Queue 2 Attention   */
 #define SAR_STAT_RSQF       0x00000040 /* Receive Status Queue full       */
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 691620d..8b04810 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -268,7 +268,7 @@
 
 /* Compatibility Error : IR Disabled */
 #define IR_LOGINFO_COMPAT_ERROR_RAID_DISABLED                  (0x00010030)
-/* Compatibility Error : Inquiry Comand failed */
+/* Compatibility Error : Inquiry Command failed */
 #define IR_LOGINFO_COMPAT_ERROR_INQUIRY_FAILED                 (0x00010031)
 /* Compatibility Error : Device not direct access device */
 #define IR_LOGINFO_COMPAT_ERROR_NOT_DIRECT_ACCESS              (0x00010032)
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 3e57b61..3358c0a 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -7977,7 +7977,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info)
 		NULL,						/* 2Eh */
 		NULL,						/* 2Fh */
 		"Compatibility Error: IR Disabled",		/* 30h */
-		"Compatibility Error: Inquiry Comand Failed",	/* 31h */
+		"Compatibility Error: Inquiry Command Failed",	/* 31h */
 		"Compatibility Error: Device not Direct Access "
 		    "Device ",					/* 32h */
 		"Compatibility Error: Removable Device Found",	/* 33h */
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..bfc8a8a 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -257,7 +257,7 @@ static u32 get_card_status(struct mmc_card *card, struct request *req)
 	cmd.flags = MMC_RSP_SPI_R2 | MMC_RSP_R1 | MMC_CMD_AC;
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
 	if (err)
-		printk(KERN_ERR "%s: error %d sending status comand",
+		printk(KERN_ERR "%s: error %d sending status command",
 		       req->rq_disk->disk_name, err);
 	return cmd.resp[0];
 }
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 41e5a60..ef72e87 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -192,7 +192,7 @@ static inline void SEND_STOP(struct au1xmmc_host *host)
 	au_writel(config2 | SD_CONFIG2_DF, HOST_CONFIG2(host));
 	au_sync();
 
-	/* Send the stop commmand */
+	/* Send the stop command */
 	au_writel(STOP_CMD, HOST_CMD(host));
 }
 
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 0f19d54..122382d 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -840,7 +840,7 @@ lcs_notify_lancmd_waiters(struct lcs_card *card, struct lcs_cmd *cmd)
 }
 
 /**
- * Emit buffer of a lan comand.
+ * Emit buffer of a lan command.
  */
 static void
 lcs_lancmd_timeout(unsigned long data)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..54a6ec8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1212,7 +1212,7 @@ static void fc_lun_reset_send(unsigned long data)
 /**
  * fc_lun_reset() - Send a LUN RESET command to a device
  *		    and wait for the reply
- * @lport: The local port to sent the comand on
+ * @lport: The local port to sent the command on
  * @fsp:   The FCP packet that identifies the LUN to be reset
  * @id:	   The SCSI command ID
  * @lun:   The LUN ID to be reset
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 2b4a048..deb24ad 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -13,7 +13,7 @@
  */
 
 /*
- * Comand coalescing - This feature allows the driver to be able to combine
+ * Command coalescing - This feature allows the driver to be able to combine
  * two or more commands and issue as one command in order to boost I/O
  * performance. Useful if the nature of the I/O is sequential. It is not very
  * useful for random natured I/Os.
diff --git a/include/scsi/fc/fc_fcp.h b/include/scsi/fc/fc_fcp.h
index 8e9b222..8a143ca 100644
--- a/include/scsi/fc/fc_fcp.h
+++ b/include/scsi/fc/fc_fcp.h
@@ -46,7 +46,7 @@
  */
 struct fcp_cmnd {
 	__u8		fc_lun[8];	/* logical unit number */
-	__u8		fc_cmdref;	/* commmand reference number */
+	__u8		fc_cmdref;	/* command reference number */
 	__u8		fc_pri_ta;	/* priority and task attribute */
 	__u8		fc_tm_flags;	/* task management flags */
 	__u8		fc_flags;	/* additional len & flags */
@@ -58,7 +58,7 @@ struct fcp_cmnd {
 
 struct fcp_cmnd32 {
 	__u8		fc_lun[8];	/* logical unit number */
-	__u8		fc_cmdref;	/* commmand reference number */
+	__u8		fc_cmdref;	/* command reference number */
 	__u8		fc_pri_ta;	/* priority and task attribute */
 	__u8		fc_tm_flags;	/* task management flags */
 	__u8		fc_flags;	/* additional len & flags */
-- 
1.7.2.3

