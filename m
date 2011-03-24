Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab1CXT1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab1CXT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ty/sx+I3FuBjtFdAv5nAQZCSwvj8OFrFYQ5QGdKi1sjdT8C2wW2iJQGyIGKgnUlV1v
         mVSIhTOP8vyB0v49Q7V0M57BS7s+/OpQhNDccvrjDPWturZh4feD/bYPDpmeVd9HJp40
         rJPqJTh57uhXGuvAMDp8fVVyeOeuGJGIbFwxM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 05/21]drivers:scsi Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:43 -0700
Message-Id: <1300994819-30930-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/be2iscsi/be_main.c   |    4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c      |    2 +-
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c    |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 24e20ba..44ac4ae 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -618,7 +618,7 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 				    + BE2_NOPOUT_REQ));
 	phba->params.cxns_per_ctrl = phba->fw_config.iscsi_cid_count;
 	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count * 2;
-	phba->params.icds_per_ctrl = phba->fw_config.iscsi_icd_count;;
+	phba->params.icds_per_ctrl = phba->fw_config.iscsi_icd_count;
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
 	phba->params.defpdu_data_sz = BE2_DEFPDU_DATA_SZ;
@@ -781,7 +781,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
 	int isr;
 
 	phba = dev_id;
-	ctrl = &phba->ctrl;;
+	ctrl = &phba->ctrl;
 	isr = ioread32(ctrl->csr + CEV_ISR0_OFFSET +
 		       (PCI_FUNC(ctrl->pdev->devfn) * CEV_ISR_SIZE));
 	if (!isr)
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 0dd43bb..04fef03 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -595,7 +595,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
 	dd_data->context_un.iocb.rspiocbq = rspiocbq;
 	dd_data->context_un.iocb.set_job = job;
-	dd_data->context_un.iocb.bmp = NULL;;
+	dd_data->context_un.iocb.bmp = NULL;
 	dd_data->context_un.iocb.ndlp = ndlp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 002360d..172cefb 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -160,7 +160,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
-	pm8001_ha = (struct pm8001_hba_info *)opaque;;
+	pm8001_ha = (struct pm8001_hba_info *)opaque;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
 	PM8001_CHIP_DISP->isr(pm8001_ha);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d17ed9a..8b4d99a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1051,7 +1051,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		}
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	} else {
-		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->result =  DID_OK << 16;
 		bsg_job->reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
@@ -1146,7 +1146,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	}
 	else {
-		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->result =  DID_OK << 16;
 		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
-- 
1.7.4.1

