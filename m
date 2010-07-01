Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab0GAV6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:58:44 -0400
Received: from kroah.org ([198.145.64.141]:33890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab0GAVNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:49 2010
Message-Id: <20100701174249.546228751@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Craig Shelley <craig@microtron.org.uk>
Subject: [037/200] USB: CP210x New Device IDs 11 New device IDs
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Craig Shelley <craig@microtron.org.uk>

commit eefd9029fde4d90d59804eeb54880ab8db5c1866 upstream.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -61,6 +61,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0BED, 0x1100) }, /* MEI (TM) Cashflow-SC Bill/Voucher Acceptor */
+	{ USB_DEVICE(0x0BED, 0x1101) }, /* MEI series 2000 Combo Acceptor */
 	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
 	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
 	{ USB_DEVICE(0x0FCF, 0x1006) }, /* Dynastream ANT development board */
@@ -72,9 +74,12 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x1601) }, /* Arkham Technology DS101 Adapter */
 	{ USB_DEVICE(0x10C4, 0x800A) }, /* SPORTident BSM7-D-USB main station */
 	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
+	{ USB_DEVICE(0x10C4, 0x8044) }, /* Cygnal Debug Adapter */
+	{ USB_DEVICE(0x10C4, 0x804E) }, /* Software Bisque Paramount ME build-in converter */
 	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
 	{ USB_DEVICE(0x10C4, 0x8054) }, /* Enfora GSM2228 */
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
+	{ USB_DEVICE(0x10C4, 0x806F) }, /* IMS USB to RS422 Converter Cable */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
 	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
@@ -82,12 +87,15 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8115) }, /* Arygon NFC/Mifare Reader */
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
+	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
 	{ USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
 	{ USB_DEVICE(0x10C4, 0x81AC) }, /* MSD Dash Hawk */
+	{ USB_DEVICE(0x10C4, 0x81AD) }, /* INSYS USB Modem */
 	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */
 	{ USB_DEVICE(0x10C4, 0x81E2) }, /* Lipowsky Industrie Elektronik GmbH, Baby-LIN */
 	{ USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
@@ -105,6 +113,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C4, 0xEA71) }, /* Infinity GPS-MIC-1 Radio Monophone */
 	{ USB_DEVICE(0x10C4, 0xF001) }, /* Elan Digital Systems USBscope50 */
 	{ USB_DEVICE(0x10C4, 0xF002) }, /* Elan Digital Systems USBwave12 */
 	{ USB_DEVICE(0x10C4, 0xF003) }, /* Elan Digital Systems USBpulse100 */
@@ -115,6 +124,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1555, 0x0004) }, /* Owen AC4 USB-RS485 Converter */
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
+	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
+	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */


