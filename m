Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1CZBoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46801 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755566Ab1CZBob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:31 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18YnpENwLoYartOui4rBLMKayldinHsmzjq6Fxnj5
	VhQ8zPRgR2Afyg
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 15/27] staging/quatech_usb2: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:43:59 +0100
Message-Id: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/quatech_usb2.

WRONG -> RIGHT
occured     -> occurred
recieve     -> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/quatech_usb2/quatech_usb2.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index c45b09e..5557342 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -148,7 +148,7 @@ static struct usb_driver quausb2_usb_driver = {
  * value of the line status flags from the port
  * @shadowMSR: Last received state of the modem status register, holds
  * the value of the modem status received from the port
- * @rcv_flush: Flag indicating that a receive flush has occured on
+ * @rcv_flush: Flag indicating that a receive flush has occurred on
  * the hardware.
  * @xmit_flush: Flag indicating that a transmit flush has been processed by
  * the hardware.
@@ -156,7 +156,7 @@ static struct usb_driver quausb2_usb_driver = {
  * includes the size (excluding header) of URBs that have been submitted but
  * have not yet been sent to to the device, and bytes that have been sent out
  * of the port but not yet reported sent by the "xmit_empty" messages (which
- * indicate the number of bytes sent each time they are recieved, despite the
+ * indicate the number of bytes sent each time they are received, despite the
  * misleading name).
  * - Starts at zero when port is initialised.
  * - is incremented by the size of the data to be written (no headers)
@@ -726,7 +726,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
 		return 0;
 	} else if (port_extra->tx_pending_bytes >= QT2_FIFO_DEPTH) {
 		/* buffer is full (==). > should not occur, but would indicate
-		 * that an overflow had occured */
+		 * that an overflow had occurred */
 		dbg("%s(): port transmit buffer is full!", __func__);
 		/* schedule_work(&port->work); commented in vendor driver */
 		return 0;
@@ -823,7 +823,7 @@ static int qt2_write_room(struct tty_struct *tty)
 	 * reduce the free space count by the size of the dispatched write.
 	 * When a "transmit empty" message comes back up the USB read stream,
 	 * we decrement the count by the number of bytes reported sent, thus
-	 * keeping track of the difference between sent and recieved bytes.
+	 * keeping track of the difference between sent and received bytes.
 	 */
 
 	room = (QT2_FIFO_DEPTH - port_extra->tx_pending_bytes);
-- 
1.7.3.4

