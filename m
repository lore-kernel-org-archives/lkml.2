Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1DQSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:09:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40429 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1DQSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UdDvknfb7xTr47Tix42y6ZH7pLu7JKwAZFI5tP+wSGO/oYCtnT4dWhZq1zmqp9IFmO
         pCdqLMXVDInazeIpuboY1bm0z7j8phozwQpAgX3IXMWfD7/HrpDdp5SWcudciRg6Dl8G
         mq4NdDYMVfnk9WeZr1J50rVGf87+WrdeGW6xc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5 v2]Typo: change whetehr to whether.
Date: Sun, 17 Apr 2011 11:09:06 -0700
Message-Id: <1303063749-8282-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch is a resend due to rebasing to the current Mainline, fixing
a typo whetehr to whether.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dacabbe..63c5d62 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3040,7 +3040,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 	pring->iocb_continueq_cnt++;
 
-	/* Now, determine whetehr the list is completed for processing */
+	/* Now, determine whether the list is completed for processing */
 	irsp = &rspiocbp->iocb;
 	if (irsp->ulpLe) {
 		/*
-- 
1.7.4.4

