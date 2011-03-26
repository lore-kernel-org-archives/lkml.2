Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1CZBjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:39:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33107 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752848Ab1CZBjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:39:53 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18L2mlU54oLYodvJshcQDW6HJ32My72tPh6KmPSZr
	+ulpB4QDGAdKI6
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 09/27] staging/ft1000: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:18 +0100
Message-Id: <1301103576-16109-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/ft1000.

WRONG -> RIGHT
recieve     -> receive
hight		-> high (in contrast to low)
interrrupt	-> interrupt

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index ff691d9..ac2ab53 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -390,10 +390,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 	}
 	mdelay(1);
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
 	} else {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
 	}
 	// clear interrupts
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 78dcd49..f796230 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -270,7 +270,7 @@ int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Parameters:  ft1000_device  - device structure
 //              indx - starting address to write the data
 //              value - 16bits value to write
-//              hightlow - high or low 16 bit word
+//              highlow - high or low 16 bit word
 //
 // Returns:     STATUS_SUCCESS - success
 //              STATUS_FAILURE - failure
@@ -611,7 +611,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	mdelay(1);
 
-	/* set watermark to -1 in order to not generate an interrrupt */
+	/* set watermark to -1 in order to not generate an interrupt */
 	ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
 	/* clear interrupts */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index e047c03..f2ecb3e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -364,7 +364,7 @@ struct prov_record {
 
 #define ISR_EMPTY			(u8)0x00 	 // no bits set in ISR
 
-#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been recieved.
+#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been received.
 
 #define ISR_DOORBELL_PEND	(u8)0x02 	 //  doorbell for me
 
-- 
1.7.3.4

