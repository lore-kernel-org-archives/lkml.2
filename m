Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1I1WhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1I1WhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.519275887@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>
Subject: [012/244] tty: Add "spi:" prefix for spi modalias
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 8c4074cd2254606aeb788d518ccc27c9f97129e1 upstream.

Since commit e0626e38 (spi: prefix modalias with "spi:"),
the spi modalias is prefixed with "spi:".

This patch adds "spi:" prefix and removes "-spi" suffix in the modalias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/max3107-aava.c |    2 +-
 drivers/tty/serial/max3107.c      |    2 +-
 drivers/tty/serial/mrst_max3110.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/max3107-aava.c
+++ b/drivers/tty/serial/max3107-aava.c
@@ -340,5 +340,5 @@ module_exit(max3107_exit);
 
 MODULE_DESCRIPTION("MAX3107 driver");
 MODULE_AUTHOR("Aavamobile");
-MODULE_ALIAS("aava-max3107-spi");
+MODULE_ALIAS("spi:aava-max3107");
 MODULE_LICENSE("GPL v2");
--- a/drivers/tty/serial/max3107.c
+++ b/drivers/tty/serial/max3107.c
@@ -1209,5 +1209,5 @@ module_exit(max3107_exit);
 
 MODULE_DESCRIPTION("MAX3107 driver");
 MODULE_AUTHOR("Aavamobile");
-MODULE_ALIAS("max3107-spi");
+MODULE_ALIAS("spi:max3107");
 MODULE_LICENSE("GPL v2");
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -917,4 +917,4 @@ module_init(serial_m3110_init);
 module_exit(serial_m3110_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("max3110-uart");
+MODULE_ALIAS("spi:max3110-uart");


