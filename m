Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1IZB7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 21:59:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40991 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1IZB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 21:59:35 -0400
Subject: [PATCH] memstick: make r592_pm_ops static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 09:59:25 +0800
Message-ID: <1317002365.5991.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/memstick/host/r592.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 668f5c6..00c1b2d 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -870,7 +870,7 @@ static int r592_resume(struct device *core_dev)
 	return 0;
 }
 
-SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
+static SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
 #endif
 
 MODULE_DEVICE_TABLE(pci, r592_pci_id_tbl);
-- 
1.7.4.1



