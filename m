Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2BAVoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:44:14 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54255 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474Ab2BAVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:10 -0500
X-Sasl-enc: Duh2qkNepheUbf6hv3B9tG64oH/OtsN/fTft69ntjrgJ 1328130549
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:42 2012
Message-Id: <20120201205742.553628569@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Renato Caldas <rmsc@fe.up.pt>
Subject: [58/65] USB: serial: CP210x: Added USB-ID for the Link Instruments MSO-19
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,6 +138,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };


