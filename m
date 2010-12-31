Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0LaRjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:39:54 -0500
Received: from mail-gw0-f66.google.com ([74.125.83.66]:43912 "EHLO
	mail-gw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0LaRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:39:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C5LM4slDmbj42I6oo+NhMK12o6X5s73kOWBbx2YdUlUGwohEmTNQoD8H1OfI5jQr0+
         dp3jlLBffyRMqUaAw5S3c+pVUBIyK1rvg4x9B3hZZTUT1inDuBDL9HSc17C9Xo3CvLkW
         OP4mzxw1HOjWMDllAdxHg9N9Ifkpde1mA6IQU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/7] scsi/aic7xxx_old/aic7xxx.reg Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:40:02 -0800
Message-Id: <1293817202-8115-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx_old/aic7xxx.reg |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.reg b/drivers/scsi/aic7xxx_old/aic7xxx.reg
index f67b4bc..13a7379 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.reg
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.reg
@@ -1296,7 +1296,7 @@ scratch_ram {
 	}
 	/*
 	 * Offset into the command descriptor array for the next
-	 * available desciptor to use.
+	 * available descriptor to use.
 	 */
 	TMODE_CMDADDR_NEXT {
 		size		1
-- 
1.6.5.2.180.gc5b3e

