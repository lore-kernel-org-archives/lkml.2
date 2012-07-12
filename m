Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161952Ab2GLXar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:30:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63475 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814Ab2GLWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Craig Shelley <craig@microtron.org.uk>
Subject: [ 097/187] USB: CP210x Add 10 Device IDs
Date: Thu, 12 Jul 2012 15:34:13 -0700
Message-Id: <20120712191531.402721325@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Craig Shelley <craig@microtron.org.uk>

commit 3fcc8f96829776cf181918461923d1e3bbb831a2 upstream.

This patch adds 10 device IDs for CP210x based devices from the following manufacturers:
Timewave
Clipsal
Festo
Link Instruments

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -93,6 +93,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+	{ USB_DEVICE(0x10C4, 0x815F) }, /* Timewave HamLinkUSB */
 	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
 	{ USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
@@ -134,7 +135,13 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10CE, 0xEA6A) }, /* Silicon Labs MobiData GPRS USB Modem 100EU */
 	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
 	{ USB_DEVICE(0x1555, 0x0004) }, /* Owen AC4 USB-RS485 Converter */
+	{ USB_DEVICE(0x166A, 0x0201) }, /* Clipsal 5500PACA C-Bus Pascal Automation Controller */
+	{ USB_DEVICE(0x166A, 0x0301) }, /* Clipsal 5800PC C-Bus Wireless PC Interface */
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
+	{ USB_DEVICE(0x166A, 0x0304) }, /* Clipsal 5000CT2 C-Bus Black and White Touchscreen */
+	{ USB_DEVICE(0x166A, 0x0305) }, /* Clipsal C-5000CT2 C-Bus Spectrum Colour Touchscreen */
+	{ USB_DEVICE(0x166A, 0x0401) }, /* Clipsal L51xx C-Bus Architectural Dimmer */
+	{ USB_DEVICE(0x166A, 0x0101) }, /* Clipsal 5560884 C-Bus Multi-room Audio Matrix Switcher */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
 	{ USB_DEVICE(0x16DC, 0x0010) }, /* W-IE-NE-R Plein & Baus GmbH PL512 Power Supply */
 	{ USB_DEVICE(0x16DC, 0x0011) }, /* W-IE-NE-R Plein & Baus GmbH RCM Remote Control for MARATON Power Supply */
@@ -146,7 +153,11 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
+	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
+	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */
+	{ USB_DEVICE(0x3195, 0xF281) }, /* Link Instruments MSO-28 */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };


