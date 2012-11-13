Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2KMRK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:10:28 -0500
Received: from sauhun.de ([89.238.76.85]:52970 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab2KMRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:10:24 -0500
X-Greylist: delayed 1335 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2012 12:10:24 EST
From: Wolfram Sang <wolfram@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Wolfram Sang <wolfram@the-dreams.de>
Subject: [PATCH] driver: platform: fix documentation for platform_get_irq_byname
Date: Tue, 13 Nov 2012 17:47:13 +0100
Message-Id: <1352825233-12714-1-git-send-email-wolfram@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably due to copy&paste, some stuff was simply forgotten.

Signed-off-by: Wolfram Sang <wolfram@the-dreams.de>
---
 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 72c776f..d7ea92e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -122,7 +122,7 @@ struct resource *platform_get_resource_byname(struct platform_device *dev,
 EXPORT_SYMBOL_GPL(platform_get_resource_byname);
 
 /**
- * platform_get_irq - get an IRQ for a device
+ * platform_get_irq_byname - get an IRQ for a device by name
  * @dev: platform device
  * @name: IRQ name
  */
-- 
1.7.10.4

