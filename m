Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0LaRwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:52:17 -0500
Received: from mail-gy0-f194.google.com ([209.85.160.194]:64101 "EHLO
	mail-gy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0LaRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pi8o+4E6zaVfM0lmPVd0pfX1QF7aERZiRMI8L/2wcQpdxe/sBcll+lxUGsWWJmdNu3
         tg0j6Q4Ioc0Vq20VjPW3swBbBcHZWZkwhok+CSth2A+pQ0IIH8BRFkaR+Afn5PLvFu+4
         g9ZxB5Sl97qJ13OIs8dfAqlEsi+R3Lq2+Mf+8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/7] scsi/aic7xxx/aic79xx.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:39:42 -0800
Message-Id: <1293817182-8081-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx/aic79xx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index be5558a..95ee503 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -672,7 +672,7 @@ struct scb_data {
 /************************ Target Mode Definitions *****************************/
 
 /*
- * Connection desciptor for select-in requests in target mode.
+ * Connection descriptor for select-in requests in target mode.
  */
 struct target_cmd {
 	uint8_t scsiid;		/* Our ID and the initiator's ID */
-- 
1.6.5.2.180.gc5b3e

