Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0DNTgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:36:54 -0400
Received: from isilmar.linta.de ([213.133.102.198]:48104 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752934Ab0DNTgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:36:53 -0400
Date: Wed, 14 Apr 2010 21:36:42 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: =?utf-8?B?UGF3ZcWC?= Drobek <pawel.drobek@gmail.com>,
       Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usb-serial: add ID for ZTE MF 330
Message-ID: <20100414193642.GL30734@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	=?utf-8?B?UGF3ZcWC?= Drobek <pawel.drobek@gmail.com>,
	Matthias Urlichs <smurf@smurf.noris.de>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201004132044.42056.pawel.drobek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201004132044.42056.pawel.drobek@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the information provided for by Paweł Drobek, add
a second vendor ID and the correct product ID for ZTE MF 330.

Reported-by: Paweł Drobek <pawel.drobek@gmail.com>
Signed-off: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ca9d866..a7f24f2 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -306,6 +306,10 @@ static int  option_resume(struct usb_serial *serial);
 #define ZTE_PRODUCT_AC8710			0xfff1
 #define ZTE_PRODUCT_AC2726			0xfff5
 
+/* ZTE PRODUCTS -- alternate vendor ID */
+#define ZTE_VENDOR_ID2				0x1d6b
+#define ZTE_PRODUCT_MF_330			0x0002
+
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
 
@@ -679,6 +683,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(ZTE_VENDOR_ID2, ZTE_PRODUCT_MF_330) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */
