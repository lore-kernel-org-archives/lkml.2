Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0KODKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:10:04 -0500
Received: from mail.perches.com ([173.55.12.10]:1195 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab0KODFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:43 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/44] drivers/scsi/lpfc: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:43 -0800
Message-Id: <1a0612305d3b141f85a6aeef6d91cd6829a80bae.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7260c3a..9e2c652 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -617,7 +617,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
 	dd_data->context_un.iocb.rspiocbq = rspiocbq;
 	dd_data->context_un.iocb.set_job = job;
-	dd_data->context_un.iocb.bmp = NULL;;
+	dd_data->context_un.iocb.bmp = NULL;
 	dd_data->context_un.iocb.ndlp = ndlp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
-- 
1.7.3.1.g432b3.dirty

