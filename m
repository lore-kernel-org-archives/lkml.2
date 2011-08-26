Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1HZUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1HZUeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/13] driver core: fix kernel-doc warning in platform.c
Date: Fri, 26 Aug 2011 13:33:43 -0700
Message-Id: <1314390834-3411-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Warning(drivers/base/platform.c:50): No description found for parameter 'pdev'
Warning(drivers/base/platform.c:50): Excess function parameter 'dev' description in 'arch_setup_pdev_archdata'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

