Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab1BKB4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:56:47 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56697 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648Ab1BKB4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:56:46 -0500
Date: Thu, 10 Feb 2011 17:56:38 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 10/10] olpc_dcon: drop CONFIG_BROKEN dependency
Message-ID: <20110210175638.0dd6f912@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


DCON builds properly now; we can drop the config dep on
CONFIG_BROKEN.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/Kconfig b/drivers/staging/olpc_dcon/Kconfig
index 982273c..acb0a79 100644
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

