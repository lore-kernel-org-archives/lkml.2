Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1G0TLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:11:31 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51404 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754114Ab1G0TL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:11:28 -0400
Date: Wed, 27 Jul 2011 12:11:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH] driver core: fix kernel-doc warning in platform.c
Message-Id: <20110727121125.03892326.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Warning(drivers/base/platform.c:50): No description found for parameter 'pdev'
Warning(drivers/base/platform.c:50): Excess function parameter 'dev' description in 'arch_setup_pdev_archdata'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-git8.orig/drivers/base/platform.c
+++ linux-3.0-git8/drivers/base/platform.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL_GPL(platform_bus);
 
 /**
  * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
- * @dev: platform device
+ * @pdev: platform device
  *
  * This is called before platform_device_add() such that any pdev_archdata may
  * be setup before the platform_notifier is called.  So if a user needs to
