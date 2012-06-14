Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2FOAA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab2FOAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:53 -0400
Message-Id: <20120614235626.543287219@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 30/42] wireless: rt2x00: rt2800usb more devices were identified
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

commit e828b9fb4f6c3513950759d5fb902db5bd054048 upstream.

found in 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

RT3070:
(0x2019,0x5201)  Planex Communications, Inc. RT8070
(0x7392,0x4085)  2L Central Europe BV 8070
7392 is Edimax

RT35xx:
(0x1690,0x0761) Askey
was Fujitsu Stylistic 550, but 1690 is Askey

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -992,6 +992,7 @@ static struct usb_device_id rt2800usb_de
 	/* DVICO */
 	{ USB_DEVICE(0x0fe9, 0xb307) },
 	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x4085) },
 	{ USB_DEVICE(0x7392, 0x7711) },
 	{ USB_DEVICE(0x7392, 0x7717) },
 	{ USB_DEVICE(0x7392, 0x7718) },
@@ -1067,6 +1068,7 @@ static struct usb_device_id rt2800usb_de
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x200f) },
 	/* Planex */
+	{ USB_DEVICE(0x2019, 0x5201) },
 	{ USB_DEVICE(0x2019, 0xab25) },
 	{ USB_DEVICE(0x2019, 0xed06) },
 	/* Quanta */
@@ -1150,6 +1152,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x8516, 0x3572) },
 	/* Askey */
 	{ USB_DEVICE(0x1690, 0x0744) },
+	{ USB_DEVICE(0x1690, 0x0761) },
 	{ USB_DEVICE(0x1690, 0x0764) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
@@ -1235,12 +1238,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
 	{ USB_DEVICE(0x2001, 0x3c17) },
-	/* Edimax */
-	{ USB_DEVICE(0x7392, 0x4085) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
-	/* Fujitsu Stylistic 550 */
-	{ USB_DEVICE(0x1690, 0x0761) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */
@@ -1261,7 +1260,6 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x05a6, 0x0101) },
 	{ USB_DEVICE(0x1d4d, 0x0010) },
 	/* Planex */
-	{ USB_DEVICE(0x2019, 0x5201) },
 	{ USB_DEVICE(0x2019, 0xab24) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259) },


