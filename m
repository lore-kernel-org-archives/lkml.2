Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab0KODKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:10:38 -0500
Received: from mail.perches.com ([173.55.12.10]:1188 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab0KODFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:42 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/44] drivers/scsi/be2iscsi: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:41 -0800
Message-Id: <7d4fbb8d3ac34861808dac24efeebe05011f6b0c.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75a85aa..db60563 100644
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
-- 
1.7.3.1.g432b3.dirty

