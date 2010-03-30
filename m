Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0C3XVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:21:41 -0400
Received: from kroah.org ([198.145.64.141]:46222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab0C3XU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:28 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:09 2010
Message-Id: <20100330224809.025773547@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nathaniel McCallum <nathaniel@natemccallum.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [075/156] USB: option: add support for a new CMOTECH device to usb/serial/option
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nathaniel McCallum <nathaniel@natemccallum.com>

commit 3b04872aa75006e2a4adaaec21e9c9ede8b8ad9d upstream.

Signed-off-by: Nathaniel McCallum <nathaniel@natemccallum.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,7 @@ static int  option_resume(struct usb_ser
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
+#define CMOTECH_PRODUCT_6008			0x6008
 #define CMOTECH_PRODUCT_6280			0x6280
 
 #define TELIT_VENDOR_ID				0x1bc7
@@ -522,6 +523,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */


