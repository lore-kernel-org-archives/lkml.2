Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0GAWTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:19:33 -0400
Received: from kroah.org ([198.145.64.141]:47207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab0GAUtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:40 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.893525207@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 024/164] ar9170usb: add a couple more USB IDs
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 94d0bbe849190255b93fede8eb46809a38f9b8bf upstream.

This patch adds the following 5 entries to the usbid device table:

 * Netgear WNA1000
 * Proxim ORiNOCO Dual Band 802.11n USB Adapter
 * 3Com Dual Band 802.11n USB Adapter
 * H3C Dual Band 802.11n USB Adapter
 * WNC Generic 11n USB dongle

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ar9170/usb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -66,18 +66,28 @@ static struct usb_device_id ar9170_usb_i
 	{ USB_DEVICE(0x0cf3, 0x1001) },
 	/* TP-Link TL-WN821N v2 */
 	{ USB_DEVICE(0x0cf3, 0x1002) },
+	/* 3Com Dual Band 802.11n USB Adapter */
+	{ USB_DEVICE(0x0cf3, 0x1010) },
+	/* H3C Dual Band 802.11n USB Adapter */
+	{ USB_DEVICE(0x0cf3, 0x1011) },
 	/* Cace Airpcap NX */
 	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160 A1 */
 	{ USB_DEVICE(0x07d1, 0x3c10) },
 	/* D-Link DWA 160 A2 */
 	{ USB_DEVICE(0x07d1, 0x3a09) },
+	/* Netgear WNA1000 */
+	{ USB_DEVICE(0x0846, 0x9040) },
 	/* Netgear WNDA3100 */
 	{ USB_DEVICE(0x0846, 0x9010) },
 	/* Netgear WN111 v2 */
 	{ USB_DEVICE(0x0846, 0x9001) },
 	/* Zydas ZD1221 */
 	{ USB_DEVICE(0x0ace, 0x1221) },
+	/* Proxim ORiNOCO 802.11n USB */
+	{ USB_DEVICE(0x1435, 0x0804) },
+	/* WNC Generic 11n USB Dongle */
+	{ USB_DEVICE(0x1435, 0x0326) },
 	/* ZyXEL NWD271N */
 	{ USB_DEVICE(0x0586, 0x3417) },
 	/* Z-Com UB81 BG */


