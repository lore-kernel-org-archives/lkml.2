Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1HOQCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:02:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61656 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1HOQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:02:17 -0400
Date: Mon, 15 Aug 2011 13:02:11 -0300 (BRT)
From: Marcos Paulo Souza <marcos.mage@gmail.com>
X-X-Sender: marcos@odin
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: base: platform.c: Fix warning on make htmldocs
Message-ID: <alpine.DEB.2.02.1108151258310.4595@odin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The function arch_setup_pdev_archdata has a parameter called pdev, but the 
documentation of the function documents a dev parameter. By changing the 
documentation parameter to pdev fix this warning.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 0cad9c7..99a5272 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL_GPL(platform_bus);
 
 /**
  * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
- * @dev: platform device
+ * @pdev: platform device
  *
  * This is called before platform_device_add() such that any pdev_archdata may
  * be setup before the platform_notifier is called.  So if a user needs to
-- 
1.7.4.1


