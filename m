Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2L1Tv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:51:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55085 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566Ab2L1TRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:43 -0500
Message-Id: <20121228190357.789446077@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 135/173] i2400m: add Intel 6150 device IDs
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 999a7c5776a0ed2133645fa7e008bec05bda9254 upstream.

Add device IDs for WiMAX function of Intel 6150 cards.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wimax/i2400m/i2400m-usb.h |    3 +++
 drivers/net/wimax/i2400m/usb.c        |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i2400m/i2400m-usb.h
index 6650fde..9f1e947 100644
--- a/drivers/net/wimax/i2400m/i2400m-usb.h
+++ b/drivers/net/wimax/i2400m/i2400m-usb.h
@@ -152,6 +152,9 @@ enum {
 	/* Device IDs */
 	USB_DEVICE_ID_I6050 = 0x0186,
 	USB_DEVICE_ID_I6050_2 = 0x0188,
+	USB_DEVICE_ID_I6150 = 0x07d6,
+	USB_DEVICE_ID_I6150_2 = 0x07d7,
+	USB_DEVICE_ID_I6150_3 = 0x07d9,
 	USB_DEVICE_ID_I6250 = 0x0187,
 };
 
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 713d033..080f363 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -510,6 +510,9 @@ int i2400mu_probe(struct usb_interface *iface,
 	switch (id->idProduct) {
 	case USB_DEVICE_ID_I6050:
 	case USB_DEVICE_ID_I6050_2:
+	case USB_DEVICE_ID_I6150:
+	case USB_DEVICE_ID_I6150_2:
+	case USB_DEVICE_ID_I6150_3:
 	case USB_DEVICE_ID_I6250:
 		i2400mu->i6050 = 1;
 		break;
@@ -759,6 +762,9 @@ static
 struct usb_device_id i2400mu_id_table[] = {
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_2) },
+	{ USB_DEVICE(0x8087, USB_DEVICE_ID_I6150_3) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6250) },
 	{ USB_DEVICE(0x8086, 0x0181) },
 	{ USB_DEVICE(0x8086, 0x1403) },


