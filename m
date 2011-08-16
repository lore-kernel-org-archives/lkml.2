Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1HPCwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab1HPCw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:29 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:53 2011
Message-Id: <20110816024453.536426067@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vijay Chavan <VijayChavan007@gmail.com>
Subject: [09/26] USB: Serial: Added device ID for Qualcomm Modem in
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 Sagemcom's HiLo3G

From: Vijay Chavan <vijaychavan007@gmail.com>

commit e468561739fffb972d486b98f66c723936335136 upstream.

A new device ID pair is added for Qualcomm Modem present in Sagemcom's HiLo3G module.

Signed-off-by: Vijay Chavan <VijayChavan007@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -45,6 +45,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */


