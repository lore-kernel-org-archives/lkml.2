Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1HUK5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 06:57:24 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:34785 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1HUK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 06:57:22 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [Doc] arch_setup_pdev_archdata: fix documentation for parameter "pdev"
Date: Sun, 21 Aug 2011 12:55:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.1-40-desktop; KDE/4.6.4; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108211255.44032.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
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
1.7.6

