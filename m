Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab2J2RE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:04:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:44992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155Ab2J2RE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:04:57 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] drivers/base: fix typo in comment for arch_setup_pdev_archdata()
Date: Mon, 29 Oct 2012 18:04:53 +0100
Message-Id: <1351530293-21763-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 8727e9c..af1d47f 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL_GPL(platform_bus);
  * be setup before the platform_notifier is called.  So if a user needs to
  * manipulate any relevant information in the pdev_archdata they can do:
  *
- * 	platform_devic_alloc()
+ *	platform_device_alloc()
  * 	... manipulate ...
  * 	platform_device_add()
  *
-- 
1.7.10.4

