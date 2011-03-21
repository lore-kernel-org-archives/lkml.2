Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CUQ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:28:44 -0400
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:56467 "EHLO
	relay2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1CUQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:28:36 -0400
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 12:28:35 EDT
X-Originating-IP: 217.70.178.34
X-Originating-IP: 74.125.82.44
MIME-Version: 1.0
From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
Date: Mon, 21 Mar 2011 17:28:10 +0100
Message-ID: <AANLkTik20MfB5yta5mRoSny8NYOt3c0Rncg-rJY1SS9R@mail.gmail.com>
Subject: [PATCH 2.6.38] bluetooth: add support for Apple MacBook Pro 8,2
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8668114..2af2e77 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -71,6 +71,9 @@ static struct usb_device_id btusb_table[] = {
     /* Apple MacBookAir3,1, MacBookAir3,2 */
     { USB_DEVICE(0x05ac, 0x821b) },

+    /* Apple MacBookPro8,2 */
+    { USB_DEVICE(0x05ac, 0x821a) },
+
     /* AVM BlueFRITZ! USB v2.0 */
     { USB_DEVICE(0x057c, 0x3800) },

--
