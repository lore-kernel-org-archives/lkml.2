Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0LaRkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:40:12 -0500
Received: from mail-gw0-f66.google.com ([74.125.83.66]:43912 "EHLO
	mail-gw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0LaRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DAA15TZiyyQPdfSNZqexQCZl1o8G0b/MBcCuRRrP0fVFuVYNLQgEY9n1C0llf1FbZ9
         mRcT5lJvpa8VfuTOBFbPpO17mT5njysiebOIM6/W87WSgGZllzAlGqvL5PO9MhTsVGf3
         elreOX1uYN0tlf7dy30U4g9eH6ZW8HfwYSotE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/7]wusbcore/rh.c Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:40:21 -0800
Message-Id: <1293817221-8148-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/wusbcore/rh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/rh.c b/drivers/usb/wusbcore/rh.c
index a68ad7a..785772e 100644
--- a/drivers/usb/wusbcore/rh.c
+++ b/drivers/usb/wusbcore/rh.c
@@ -156,7 +156,7 @@ int wusbhc_rh_status_data(struct usb_hcd *usb_hcd, char *_buf)
 EXPORT_SYMBOL_GPL(wusbhc_rh_status_data);
 
 /*
- * Return the hub's desciptor
+ * Return the hub's descriptor
  *
  * NOTE: almost cut and paste from ehci-hub.c
  *
-- 
1.6.5.2.180.gc5b3e

