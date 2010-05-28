Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0E1Mtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:49:55 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:43784 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0E1Mtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:49:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MAINTAINERS: some Atmel drivers change maintainer
Date: Fri, 28 May 2010 15:54:48 +0200
Message-Id: <1275054888-13828-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20100528114245.3d030692@hskinnemoen-d830>
References: <20100528114245.3d030692@hskinnemoen-d830>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I take over the maintenance of SPI, USART, Ethernet and USB gadget drivers.
Those drivers are found in Atmel microcontrollers, both AT32/AVR32 and
AT91/ARM.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Haavard,
I finally change the MAINTAINERS entries for all drivers that you were
taking care of. I must admit that I was a bit frighten at the first place but
anyway, since one year, I am getting used to it ;-)


 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 33047a6..d9ce9c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1148,7 +1148,7 @@ F:	drivers/mmc/host/atmel-mci.c
 F:	drivers/mmc/host/atmel-mci-regs.h
 
 ATMEL AT91 / AT32 SERIAL DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/serial/atmel_serial.c
 
@@ -1160,18 +1160,18 @@ F:	drivers/video/atmel_lcdfb.c
 F:	include/video/atmel_lcdc.h
 
 ATMEL MACB ETHERNET DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/spi/atmel_spi.*
 
 ATMEL USBA UDC DRIVER
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
-L:	kernel@avr32linux.org
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
 S:	Supported
 F:	drivers/usb/gadget/atmel_usba_udc.*
-- 
1.5.6.5

