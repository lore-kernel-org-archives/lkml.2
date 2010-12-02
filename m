Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0LBCqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:46:17 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:46035 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0LBCqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:46:15 -0500
Date: Wed, 1 Dec 2010 18:46:11 -0800
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org, cjb@laptop.org,
        jon.nettleton@gmail.com, dsd@laptop.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: [PATCH] staging: olpc_dcon: drop CONFIG_BROKEN dependency
Message-ID: <20101201184611.6e40d517@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the last few commits, the DCON will now properly build.  As such,
drop the dep on CONFIG_BROKEN.

[Note: this is for the -mm tree, to be applied on top of the other DCON
patches.]

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/Kconfig b/drivers/staging/olpc_dcon/Kconfig
index 8be8716..cfdec44 100644
--- a/drivers/staging/olpc_dcon/Kconfig
+++ b/drivers/staging/olpc_dcon/Kconfig
@@ -1,6 +1,6 @@
 config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
-	depends on OLPC && BROKEN
+	depends on OLPC
 	select I2C
 	---help---
 	  Add support for the OLPC XO DCON controller.  This controller is
-- 
1.7.2.3

