Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab0FKKSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:18:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37012 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab0FKKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] trivial: fix typos concerning "management"
Date: Fri, 11 Jun 2010 12:17:01 +0200
Message-Id: <1276251424-12806-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
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
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |    2 +-
 drivers/media/dvb/siano/smscoreapi.c     |    2 +-
 drivers/net/benet/be_hw.h                |    2 +-
 drivers/scsi/fcoe/fcoe.c                 |    4 ++--
 drivers/scsi/mpt2sas/mpt2sas_base.h      |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     |    4 ++--
 drivers/scsi/pm8001/pm8001_hwi.c         |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c          |    2 +-
 drivers/scsi/qla2xxx/qla_nx.h            |    2 +-
 include/linux/ide.h                      |    2 +-
 include/linux/if_link.h                  |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 8612378..5f2d5df 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -1017,7 +1017,7 @@ int vmw_gmr_id_alloc(struct vmw_private *dev_priv, uint32_t *p_id)
 }
 
 /*
- * Stream managment
+ * Stream management
  */
 
 static void vmw_stream_destroy(struct vmw_resource *res)
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 0c87a3c..a19f649 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1297,7 +1297,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 EXPORT_SYMBOL_GPL(smsclient_sendrequest);
 
 
-/* old GPIO managments implementation */
+/* old GPIO managements implementation */
 int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
 			   struct smscore_config_gpio *pinconfig)
 {
diff --git a/drivers/net/benet/be_hw.h b/drivers/net/benet/be_hw.h
index 063026d..3f1b7c3 100644
--- a/drivers/net/benet/be_hw.h
+++ b/drivers/net/benet/be_hw.h
@@ -52,7 +52,7 @@
  */
 #define MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK	(1 << 29) /* bit 29 */
 
-/********* Power managment (WOL) **********/
+/********* Power management (WOL) **********/
 #define PCICFG_PM_CONTROL_OFFSET		0x44
 #define PCICFG_PM_CONTROL_MASK			0x108	/* bits 3 & 8 */
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 44a0759..fe568ef 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2452,7 +2452,7 @@ module_exit(fcoe_exit);
  * @fp: response frame, or error encoded in a pointer (timeout)
  * @arg: pointer the the fcoe_ctlr structure
  *
- * This handles MAC address managment for FCoE, then passes control on to
+ * This handles MAC address management for FCoE, then passes control on to
  * the libfc FLOGI response handler.
  */
 static void fcoe_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
@@ -2484,7 +2484,7 @@ done:
  * @fp: response frame, or error encoded in a pointer (timeout)
  * @arg: pointer the the fcoe_ctlr structure
  *
- * This handles MAC address managment for FCoE, then passes control on to
+ * This handles MAC address management for FCoE, then passes control on to
  * the libfc LOGO response handler.
  */
 static void fcoe_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b4afe43..41c29a8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -474,7 +474,7 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @shost_recovery: host reset in progress
  * @ioc_reset_in_progress_lock:
  * @ioc_link_reset_in_progress: phy/hard reset in progress
- * @ignore_loginfos: ignore loginfos during task managment
+ * @ignore_loginfos: ignore loginfos during task management
  * @remove_host: flag for when driver unloads, to avoid sending dev resets
  * @wait_for_port_enable_to_complete:
  * @msix_enable: flag indicating msix is enabled
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c5ff26a..06d645a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2979,7 +2979,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	/* host recovery or link resets sent via IOCTLs */
 	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	/* device busy with task managment */
+	/* device busy with task management */
 	else if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	/* device has been deleted */
@@ -6845,7 +6845,7 @@ _scsih_init(void)
 	 /* queuecommand callback hander */
 	scsi_io_cb_idx = mpt2sas_base_register_callback_handler(_scsih_io_done);
 
-	/* task managment callback handler */
+	/* task management callback handler */
 	tm_cb_idx = mpt2sas_base_register_callback_handler(_scsih_tm_done);
 
 	/* base internal commands callback handler */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 3b11fd8..e81efac 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4152,7 +4152,7 @@ static int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 }
 
 /**
- * pm8001_chip_ssp_tm_req - built the task managment command.
+ * pm8001_chip_ssp_tm_req - built the task management command.
  * @pm8001_ha: our hba card information.
  * @ccb: the ccb information.
  * @tmf: task management function.
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8ef9453..782b30d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1129,7 +1129,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	cmd_pkt->fcp_cmnd_dseg_address[1] = cpu_to_le32(
 	    MSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
 	fcp_cmnd->task_attribute = 0;
-	fcp_cmnd->task_managment = 0;
+	fcp_cmnd->task_management = 0;
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index f8f99a5..1b44d01 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -832,7 +832,7 @@ struct fcp_cmnd {
 	struct scsi_lun lun;
 	uint8_t crn;
 	uint8_t task_attribute;
-	uint8_t task_managment;
+	uint8_t task_management;
 	uint8_t additional_cdb_len;
 	uint8_t cdb[260]; /* 256 for CDB len and 4 for FCP_DL */
 };
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 7b02aa5..072fe8c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -458,7 +458,7 @@ enum {
 	IDE_DFLAG_DOORLOCKING		= (1 << 15),
 	/* disallow DMA */
 	IDE_DFLAG_NODMA			= (1 << 16),
-	/* powermanagment told us not to do anything, so sleep nicely */
+	/* powermanagement told us not to do anything, so sleep nicely */
 	IDE_DFLAG_BLOCKED		= (1 << 17),
 	/* sleeping & sleep field valid */
 	IDE_DFLAG_SLEEPING		= (1 << 18),
diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 85c812d..9d8f080 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -233,7 +233,7 @@ enum macvlan_mode {
 	MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
 };
 
-/* SR-IOV virtual function managment section */
+/* SR-IOV virtual function management section */
 
 enum {
 	IFLA_VF_INFO_UNSPEC,
-- 
1.7.1

