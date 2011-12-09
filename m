Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1LIIOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:14:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60741 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301Ab1LIIOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:14:15 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 8/8] MAINTAINERS: spi: Update F: patterns
Date: Fri,  9 Dec 2011 00:12:54 -0800
Message-Id: <86f4a9099c8ff7961190a540155356446dda2ade.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ca632f55669 ("spi: reorganize drivers")
renamed the files, update the F: patterns.

CC: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 410f190..68d5147 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1151,7 +1151,7 @@ F:	drivers/watchdog/nuc900_wdt.c
 F:	drivers/net/ethernet/nuvoton/w90p910_ether.c
 F:	drivers/mtd/nand/nuc900_nand.c
 F:	drivers/rtc/rtc-nuc900.c
-F:	drivers/spi/spi_nuc900.c
+F:	drivers/spi/spi-nuc900.c
 F:	drivers/usb/host/ehci-w90x900.c
 F:	drivers/video/nuc900fb.c
 
@@ -1355,7 +1355,7 @@ F:	drivers/net/ethernet/cadence/
 ATMEL SPI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
-F:	drivers/spi/atmel_spi.*
+F:	drivers/spi/spi-atmel.*
 
 ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
@@ -5280,7 +5280,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
-F:	drivers/spi/pxa2xx*
+F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
-- 
1.7.8.111.gad25c.dirty

