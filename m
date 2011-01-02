Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1ABHa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:30:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:37166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab1ABHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, DJ Delorie <dj@delorie.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 249/260] USB: cp210x: Add Renesas RX-Stick device ID
Date: Sun,  2 Jan 2011 02:19:05 -0500
Message-Id: <1293952756-15010-250-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:41.0902 (UTC) FILETIME=[1F45A4E0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: DJ Delorie <dj@delorie.com>

commit 2f1136d1d08a63dcdbcd462621373f30d8dfe590 upstream.

RX610 development board by Renesas

Bus 001 Device 024: ID 045b:0053 Hitachi, Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x045b Hitachi, Ltd
  idProduct          0x0053
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 RX-Stick
  iSerial                 3 0001
  . . .

http://am.renesas.com/rx610stick

Signed-off-by: DJ Delorie <dj@delorie.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index c39349f..05f7f48 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -56,6 +56,7 @@ static int cp210x_carrier_raised(struct usb_serial_port *p);
 static int debug;
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
-- 
1.7.3.3

