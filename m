Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2KEQGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:06:06 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7191 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2KEQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:06:04 -0500
Date: Mon, 5 Nov 2012 17:05:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] MAINTAINERS: i2c: 7 years, this is it
Message-ID: <20121105170554.1972f3c2@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been maintaining the i2c subsystem for 7 years now, it's about
time to let someone else take over. Just before I leave, I would like
to thank several individuals who made this possible at all:

* Greg Kroah-Hartman, for his faith in my potential subsystem
  maintainer skills. Greg, I hope I met your expectations.
* Late David Brownell, for helping me convert the i2c subsystem to the
  standard device driver model. Rest in peace David, we're missing you.
* Ben Dooks, for stepping in when I asked for someone to take care of
  the huge flow of new i2c adapter drivers for embedded systems.
* Wolfram Sang, for joining the crew when it became clear that there
  was more review work than Ben and myself could deal with.

I hope I did not forget anyone, please forgive me if I did.

Another big thank is due to Wolfram again, who quickly proposed to
take over as the main i2c subsystem maintainer. This will allow for a
smooth and fast transition.

Note that I will keep maintaining all I2C/SMBus controller drivers for
PC systems as well as a few others. I am hereby updating MAINTAINERS
accordingly. I'll also keep maintaining user-space i2c-tools.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 MAINTAINERS |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 9 deletions(-)

--- linux-3.7-rc4.orig/MAINTAINERS	2012-11-05 16:35:07.797419133 +0100
+++ linux-3.7-rc4/MAINTAINERS	2012-11-05 17:00:25.958721344 +0100
@@ -3598,6 +3598,49 @@ F:	drivers/hid/hid-hyperv.c
 F:	drivers/net/hyperv/
 F:	drivers/staging/hv/
 
+I2C OVER PARALLEL PORT
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-parport
+F:	Documentation/i2c/busses/i2c-parport-light
+F:	drivers/i2c/busses/i2c-parport.c
+F:	drivers/i2c/busses/i2c-parport-light.c
+
+I2C/SMBUS CONTROLLER DRIVERS FOR PC
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-ali1535
+F:	Documentation/i2c/busses/i2c-ali1563
+F:	Documentation/i2c/busses/i2c-ali15x3
+F:	Documentation/i2c/busses/i2c-amd756
+F:	Documentation/i2c/busses/i2c-amd8111
+F:	Documentation/i2c/busses/i2c-i801
+F:	Documentation/i2c/busses/i2c-nforce2
+F:	Documentation/i2c/busses/i2c-piix4
+F:	Documentation/i2c/busses/i2c-sis5595
+F:	Documentation/i2c/busses/i2c-sis630
+F:	Documentation/i2c/busses/i2c-sis96x
+F:	Documentation/i2c/busses/i2c-via
+F:	Documentation/i2c/busses/i2c-viapro
+F:	drivers/i2c/busses/i2c-ali1535.c
+F:	drivers/i2c/busses/i2c-ali1563.c
+F:	drivers/i2c/busses/i2c-ali15x3.c
+F:	drivers/i2c/busses/i2c-amd756.c
+F:	drivers/i2c/busses/i2c-amd756-s4882.c
+F:	drivers/i2c/busses/i2c-amd8111.c
+F:	drivers/i2c/busses/i2c-i801.c
+F:	drivers/i2c/busses/i2c-isch.c
+F:	drivers/i2c/busses/i2c-nforce2.c
+F:	drivers/i2c/busses/i2c-nforce2-s4985.c
+F:	drivers/i2c/busses/i2c-piix4.c
+F:	drivers/i2c/busses/i2c-sis5595.c
+F:	drivers/i2c/busses/i2c-sis630.c
+F:	drivers/i2c/busses/i2c-sis96x.c
+F:	drivers/i2c/busses/i2c-via.c
+F:	drivers/i2c/busses/i2c-viapro.c
+
 I2C/SMBUS STUB DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
@@ -3605,9 +3648,8 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-stub.c
 
 I2C SUBSYSTEM
-M:	"Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
+M:	Wolfram Sang <w.sang@pengutronix.de>
 M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
-M:	"Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
@@ -3618,6 +3660,13 @@ F:	drivers/i2c/
 F:	include/linux/i2c.h
 F:	include/linux/i2c-*.h
 
+I2C-TAOS-EVM DRIVER
+M:	Jean Delvare <khali@linux-fr.org>
+L:	linux-i2c@vger.kernel.org
+S:	Maintained
+F:	Documentation/i2c/busses/i2c-taos-evm
+F:	drivers/i2c/busses/i2c-taos-evm.c
+
 I2C-TINY-USB DRIVER
 M:	Till Harbaum <till@harbaum.org>
 L:	linux-i2c@vger.kernel.org
@@ -7887,13 +7936,6 @@ M:	Roger Luethi <rl@hellgate.ch>
 S:	Maintained
 F:	drivers/net/ethernet/via/via-rhine.c
 
-VIAPRO SMBUS DRIVER
-M:	Jean Delvare <khali@linux-fr.org>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/i2c/busses/i2c-viapro
-F:	drivers/i2c/busses/i2c-viapro.c
-
 VIA SD/MMC CARD CONTROLLER DRIVER
 M:	Bruce Chang <brucechang@via.com.tw>
 M:	Harald Welte <HaraldWelte@viatech.com>

-- 
Jean Delvare
