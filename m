Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab2JKA0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:26:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42370 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933384Ab2JKAZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:25:57 -0400
X-Sasl-enc: 3rAat1etJeCs7th0vCMj2GD32x+c63gIrvXVr2UW8TBR 1349915156
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Quinlan Pfiffer <qpfiffer@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 108/122] asix: Adds support for Lenovo 10/100 USB dongle.
Date: Thu, 11 Oct 2012 07:54:34 +0900
Message-Id: <20121010225357.449596890@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinlan Pfiffer <qpfiffer@gmail.com>

commit 66dc81ecd71332783c92fb170950d5ddb43da461 upstream.

This dongle ships with the X1 Carbon, and has an AX88772B
usb to ethernet chip in it.

Signed-off-by: Quinlan Pfiffer <qpfiffer@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/asix_devices.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -930,6 +930,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x04f1, 0x3008),
 	.driver_info = (unsigned long) &ax8817x_info,
 }, {
+	// Lenovo U2L100P 10/100
+	USB_DEVICE (0x17ef, 0x7203),
+	.driver_info = (unsigned long) &ax88772_info,
+}, {
 	// ASIX AX88772B 10/100
 	USB_DEVICE (0x0b95, 0x772b),
 	.driver_info = (unsigned long) &ax88772_info,


