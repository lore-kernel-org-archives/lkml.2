Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1AMS7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:59:05 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41741 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab1AMS7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:59:03 -0500
Date: Thu, 13 Jan 2011 10:58:59 -0800
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org, cjb@laptop.org,
        jon.nettleton@gmail.com, dsd@laptop.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: [PATCH resend] staging: olpc_dcon: drop CONFIG_BROKEN dependency
Message-ID: <20110113105859.59b045eb@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the recent commits, the DCON will now properly build.  As such,
drop the dep on CONFIG_BROKEN.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/Kconfig
b/drivers/staging/olpc_dcon/Kconfig index 8be8716..cfdec44 100644
--- a/drivers/staging/olpc_dcon/Kconfig
+++ b/drivers/staging/olpc_dcon/Kconfig
@@ -1,6 +1,6 @@
 config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
-	depends on OLPC && BROKEN
+	depends on OLPC
 	select I2C
 	---help---
 	  Add support for the OLPC XO DCON controller.  This
controller is
-- 
1.7.2.3

