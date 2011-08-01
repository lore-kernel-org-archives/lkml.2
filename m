Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1HANU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:20:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50830 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1HANUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:20:21 -0400
Subject: [PATCH] tty: Add "spi:" prefix for spi modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 21:20:10 +0800
Message-ID: <1312204810.4852.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit e0626e38 (spi: prefix modalias with "spi:"),
the spi modalias is prefixed with "spi:".

This patch adds "spi:" prefix and removes "-spi" suffix in the modalias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/tty/serial/max3107-aava.c |    2 +-
 drivers/tty/serial/max3107.c      |    2 +-
 drivers/tty/serial/mrst_max3110.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/max3107-aava.c b/drivers/tty/serial/max3107-aava.c
index 0b98a77..90c40f2 100644
--- a/drivers/tty/serial/max3107-aava.c
+++ b/drivers/tty/serial/max3107-aava.c
@@ -341,5 +341,5 @@ module_exit(max3107_exit);
 
 MODULE_DESCRIPTION("MAX3107 driver");
 MODULE_AUTHOR("Aavamobile");
-MODULE_ALIAS("aava-max3107-spi");
+MODULE_ALIAS("spi:aava-max3107");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/max3107.c b/drivers/tty/serial/max3107.c
index 8d56d1b..a50f406 100644
--- a/drivers/tty/serial/max3107.c
+++ b/drivers/tty/serial/max3107.c
@@ -1210,5 +1210,5 @@ module_exit(max3107_exit);
 
 MODULE_DESCRIPTION("MAX3107 driver");
 MODULE_AUTHOR("Aavamobile");
-MODULE_ALIAS("max3107-spi");
+MODULE_ALIAS("spi:max3107");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index a764bf9..23bc743 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -917,4 +917,4 @@ module_init(serial_m3110_init);
 module_exit(serial_m3110_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("max3110-uart");
+MODULE_ALIAS("spi:max3110-uart");
-- 
1.7.4.1



