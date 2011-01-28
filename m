Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1A1TtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:49:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53837 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1A1TtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HtM23ovtL0A6RjV1+SHn1RCYC5CvgDtTZD1q7nBYo0wYFWOerm4djlrKz5pR5VdFTw
         e7yCypDX74OXsVfV7Q4x55xi0iVf0U9wQLN1HIwWDqlZPDtQ1L1TIok4ZezDQ4KBKy5I
         TnX5m6EhyLVC9mW3a3I7/TEi79gfWyBXVfB1c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:scsi Change initate to initiate.
Date: Fri, 28 Jan 2011 11:49:08 -0800
Message-Id: <1296244148-3808-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6ffbe97..03e028e 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1027,7 +1027,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 					((ddb_entry->default_time2wait +
 					  4) * HZ);
 
-				DEBUG2(printk("scsi%ld: ddb [%d] initate"
+				DEBUG2(printk("scsi%ld: ddb [%d] initiate"
 					      " RELOGIN after %d seconds\n",
 					      ha->host_no,
 					      ddb_entry->fw_ddb_index,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3fc1d25..967836e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -812,7 +812,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 					);
 				start_dpc++;
 				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
-					     "initate relogin after"
+					     "initiate relogin after"
 					     " %d seconds\n",
 					     ha->host_no, ddb_entry->bus,
 					     ddb_entry->target,
-- 
1.6.5.GIT

