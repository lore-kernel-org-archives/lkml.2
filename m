Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2BAVH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:07:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37209 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab2BAVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:50 -0500
X-Sasl-enc: mpfeDyQLSq2VpSHzUU1FHAoUDlitLgfY+MQQx7XL4i+L 1328130469
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:32 2012
Message-Id: <20120201201532.623612784@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Renato Caldas <rmsc@fe.up.pt>
Subject: [19/20] USB: serial: CP210x: Added USB-ID for the Link Instruments MSO-19
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Renato Caldas <rmsc@fe.up.pt>

commit 791b7d7cf69de11275e4dccec2f538eec02cbff6 upstream.

This device is a Oscilloscope/Logic Analizer/Pattern Generator/TDR,
using a Silabs CP2103 USB to UART Bridge.

Signed-off-by: Renato Caldas <rmsc@fe.up.pt>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -140,6 +140,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };


