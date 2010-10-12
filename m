Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0JLNeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:34:13 -0400
Received: from mail.danysek.cz ([91.103.163.139]:46491 "EHLO mail.danysek.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0JLNeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:34:11 -0400
Message-ID: <4CB463D1.4020204@danysek.cz>
Date: Tue, 12 Oct 2010 15:34:09 +0200
From: Daniel Suchy <danny@danysek.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Mnenhy/0.8.3 Icedove/3.1.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PATCH: ftdi_sio new VID/PIDs for various Papouch devices
References: <4CB45E2A.9020407@danysek.cz> <20101012132208.GB10556@suse.de>
In-Reply-To: <20101012132208.GB10556@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------050108050600080806020403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050108050600080806020403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,
in attached file I'm provided updated patch with removed unnecessary
comment.

Signed-off-by: Daniel Suchy <danny@danysek.cz>

On 10/12/2010 03:22 PM, Greg KH wrote:
> On Tue, Oct 12, 2010 at 03:10:02PM +0200, Daniel Suchy wrote:
> Hello,
> in attached file, there's patch for FTDI USB serial converter adding new
> VID/PIDs used on various devices manufactured by Papouch
> (http://www.papouch.com). These devices have their own VID/PID, although
> they're using standard FTDI chip. In ftdi_sio.c, I also made small
> cleanup to have declarations for all Papouch devices in single section.
> 
> My patch was tested against 2.6.35.x stable kernel releases at this time.
> 
> With regards,
> Daniel Suchy

This is not needed, you get this information from the changelog information.

Care to take this line out, and add a "Signed-off-by:" line as per the
Documentation/SubmittingPatches file?  That's required for me to be able
to accept the patch.

thanks,

greg k-h

--------------050108050600080806020403
Content-Type: text/x-diff;
 name="ftdi_sio-papouch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ftdi_sio-papouch.patch"

--- drivers/usb/serial/ftdi_sio_ids.h.orig	2010-09-08 08:57:36.000000000 +0200
+++ drivers/usb/serial/ftdi_sio_ids.h	2010-10-12 15:26:34.384586002 +0200
@@ -1010,9 +1010,34 @@
  */
 
 #define PAPOUCH_VID			0x5050	/* Vendor ID */
+#define PAPOUCH_SB485_PID		0x0100	/* Papouch SB485 USB-485/422 Converter */
+#define PAPOUCH_AP485_PID		0x0101	/* AP485 USB-RS485 Converter */
+#define PAPOUCH_SB422_PID		0x0102	/* Papouch SB422 USB-RS422 Converter  */
+#define PAPOUCH_SB485_2_PID		0x0103	/* Papouch SB485 USB-485/422 Converter */
+#define PAPOUCH_AP485_2_PID		0x0104	/* AP485 USB-RS485 Converter */
+#define PAPOUCH_SB422_2_PID		0x0105	/* Papouch SB422 USB-RS422 Converter  */
+#define PAPOUCH_SB485S_PID		0x0106	/* Papouch SB485S USB-485/422 Converter */
+#define PAPOUCH_SB485C_PID		0x0107	/* Papouch SB485C USB-485/422 Converter */
+#define PAPOUCH_LEC_PID			0x0300	/* LEC USB Converter */
+#define PAPOUCH_SB232_PID		0x0301	/* Papouch SB232 USB-RS232 Converter */
 #define PAPOUCH_TMU_PID			0x0400	/* TMU USB Thermometer */
-#define PAPOUCH_QUIDO4x4_PID		0x0900	/* Quido 4/4 Module */
+#define PAPOUCH_IRAMP_PID		0x0500	/* Papouch IRAmp Duplex */
+#define PAPOUCH_DRAK5_PID		0x0700	/* Papouch DRAK5 */
+#define PAPOUCH_QUIDO8x8_PID		0x0800	/* Papouch Quido 8/8 Module */
+#define PAPOUCH_QUIDO4x4_PID		0x0900	/* Papouch Quido 4/4 Module */
+#define PAPOUCH_QUIDO2x2_PID		0x0a00	/* Papouch Quido 2/2 Module */
+#define PAPOUCH_QUIDO10x1_PID		0x0b00	/* Papouch Quido 10/1 Module */
+#define PAPOUCH_QUIDO30x3_PID		0x0c00	/* Papouch Quido 30/3 Module */
+#define PAPOUCH_QUIDO60x3_PID		0x0d00	/* Papouch Quido 60(100)/3 Module */
+#define PAPOUCH_QUIDO2x16_PID		0x0e00	/* Papouch Quido 2/16 Module */
+#define PAPOUCH_QUIDO3x32_PID		0x0f00	/* Papouch Quido 3/32 Module */
+#define PAPOUCH_DRAK6_PID		0x1000	/* Papouch DRAK6 */
+#define PAPOUCH_UPSUSB_PID		0x8000	/* Papouch UPS-USB adapter */
+#define PAPOUCH_MU_PID			0x8001	/* MU controller */
+#define PAPOUCH_SIMUKEY_PID		0x8002	/* Papouch SimuKey */
 #define PAPOUCH_AD4USB_PID		0x8003	/* AD4USB Measurement Module */
+#define PAPOUCH_GMUX_PID		0x8004	/* Papouch GOLIATH MUX */
+#define PAPOUCH_GMSR_PID		0x8005	/* Papouch GOLIATH MSR */
 
 /*
  * Marvell SheevaPlug
--- drivers/usb/serial/ftdi_sio.c.orig	2010-09-08 08:57:36.000000000 +0200
+++ drivers/usb/serial/ftdi_sio.c	2010-10-12 14:29:57.992586000 +0200
@@ -674,7 +674,6 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
 	{ USB_DEVICE(ICOM_ID1_VID, ICOM_ID1_PID) },
-	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_TMU_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
@@ -715,8 +714,37 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
+
+	/* Papouch devices based on FTDI chip */
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AP485_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB422_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AP485_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB422_2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485S_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB485C_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_LEC_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SB232_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_TMU_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_IRAMP_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_DRAK5_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO8x8_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO2x2_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO10x1_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO30x3_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO60x3_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO2x16_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO3x32_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_DRAK6_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_UPSUSB_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_MU_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_SIMUKEY_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AD4USB_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_GMUX_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_GMSR_PID) },
+
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },

--------------050108050600080806020403--
