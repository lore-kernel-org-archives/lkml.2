Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1FWGaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:30:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57874 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1FWGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lSkf3LUFVzZZcAWnPOwSD5x78pNsmIQFmRpdELW/HT+i49w43elviJTAOWmv8Ua0xS
         iP5Ozlui8DDMvr38cG4zA9nWtYHvKRS3AF/S242xr+cH8wmlx+baPvEQqEwDO0OZjCAv
         gorwJI3YhPE6DCJCEeJQBCBZz1SEAlfPTvWYE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/3]drivers:ata:sata_dwc_460ex.c Fix typo corrresponding.
Date: Wed, 22 Jun 2011 23:29:20 -0700
Message-Id: <1308810560-23742-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
References: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/ata/sata_dwc_460ex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 1c4b3aa..dc88a39 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -389,7 +389,7 @@ static void sata_dwc_tf_dump(struct ata_taskfile *tf)
 /*
  * Function: get_burst_length_encode
  * arguments: datalength: length in bytes of data
- * returns value to be programmed in register corrresponding to data length
+ * returns value to be programmed in register corresponding to data length
  * This value is effectively the log(base 2) of the length
  */
 static  int get_burst_length_encode(int datalength)
-- 
1.7.5.4

