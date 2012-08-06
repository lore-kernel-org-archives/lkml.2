Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2HFPAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:00:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51895 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2HFPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:00:39 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: mfm@muteddisk.com
Cc: gregkh@linuxfoundation.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]staging "usbip" Fix typos.
Date: Mon,  6 Aug 2012 08:00:27 -0700
Message-Id: <1344265227-336-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
NOTE:I see *rc1 in the git web log, so hopefully its ok to send out.
The below patch fixes typos found while reading through staging usbip.

 drivers/staging/usbip/stub_rx.c  |    2 +-
 drivers/staging/usbip/vhci_hcd.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 1d5b3fc..694cfd7 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -155,7 +155,7 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	 * eventually reassigned to the device as far as driver matching
 	 * condition is kept.
 	 *
-	 * Unfortunatelly, an existing usbip connection will be dropped
+	 * Unfortunately, an existing usbip connection will be dropped
 	 * due to this driver unbinding. So, skip here.
 	 * A user may need to set a special configuration value before
 	 * exporting the device.
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 12a9a5f..a5b028d 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -828,11 +828,11 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 	 *	disable endpoints. pending urbs are unlinked(dequeued).
 	 *
 	 * NOTE: After calling rh_port_disconnect(), the USB device drivers of a
-	 * deteched device should release used urbs in a cleanup function(i.e.
+	 * detached device should release used urbs in a cleanup function (i.e.
 	 * xxx_disconnect()). Therefore, vhci_hcd does not need to release
 	 * pushed urbs and their private data in this function.
 	 *
-	 * NOTE: vhci_dequeue() must be considered carefully. When shutdowning
+	 * NOTE: vhci_dequeue() must be considered carefully. When shutting down
 	 * a connection, vhci_shutdown_connection() expects vhci_dequeue()
 	 * gives back pushed urbs and frees their private data by request of
 	 * the cleanup function of a USB driver. When unlinking a urb with an
-- 
1.7.5.4

