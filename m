Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0C3XSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:18:46 -0400
Received: from kroah.org ([198.145.64.141]:45276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0C3XS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:29 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:44 2010
Message-Id: <20100330225643.949116399@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nathaniel McCallum <nathaniel@natemccallum.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [070/116] USB: option: move hardcoded PID to a macro in usb/serial/option
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nathaniel McCallum <nathaniel@natemccallum.com>

commit bb73ed2a268a29ab1b7d8cc50b5f248578e7e188 upstream.

Signed-off-by: Nathaniel McCallum <nathaniel@natemccallum.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,7 @@ static int  option_resume(struct usb_ser
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
+#define CMOTECH_PRODUCT_6280			0x6280
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
@@ -520,7 +521,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */


