Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1FXGWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:22:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38042 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1FXGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uffonETlzPkCMq5WV+6dKyobDabSPrs90AbpfZkJFK7Z/GUyxCzVKYJM4etySO6guI
         W9zDys5GICViwZQSUZgWhPI9hB8z0T1go1yB8B01NDCJ7FgJ6vuuEUk8YAx/CrV96SrO
         zvBZki19Io4myGuWojwY9/7/AQS8KJl+JOqtM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3]drivers:scsi:qla2xxx:qla_isr.c Typo fix hammmer.
Date: Thu, 23 Jun 2011 23:22:27 -0700
Message-Id: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b60a95..ae8e298 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -63,7 +63,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 
 			/*
 			 * Issue a "HARD" reset in order for the RISC interrupt
-			 * bit to be cleared.  Schedule a big hammmer to get
+			 * bit to be cleared.  Schedule a big hammer to get
 			 * out of the RISC PAUSED state.
 			 */
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
@@ -169,7 +169,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			/*
 			 * Issue a "HARD" reset in order for the RISC
 			 * interrupt bit to be cleared.  Schedule a big
-			 * hammmer to get out of the RISC PAUSED state.
+			 * hammer to get out of the RISC PAUSED state.
 			 */
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
-- 
1.7.5.4

