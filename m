Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0LaRjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:39:14 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:47976 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0LaRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZK04zHPGLDBOx9VFkfMM16tRYloQH+WfK036YPsXZk6bOEPYnZ3rBPQ/jR15jmyHC1
         5P4enJWlA/DyUKuWH/5mwGtcuoqInj3f9El/6lvznrNuTcXoEwpz5JmqqYHWG2IUaOAf
         M4foVk56TLRD411ZqXnjGwcNq0tqKNwcMAKkg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/7] scsi/aic7xxx/aic7xxx.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:39:22 -0800
Message-Id: <1293817162-8046-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx/aic7xxx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index e4e651c..17444bc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -618,7 +618,7 @@ struct scb_data {
 /************************ Target Mode Definitions *****************************/
 
 /*
- * Connection desciptor for select-in requests in target mode.
+ * Connection descriptor for select-in requests in target mode.
  */
 struct target_cmd {
 	uint8_t scsiid;		/* Our ID and the initiator's ID */
-- 
1.6.5.2.180.gc5b3e

