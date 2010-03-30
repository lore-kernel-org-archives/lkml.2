Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab0CaA0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:26:34 -0400
Received: from kroah.org ([198.145.64.141]:48980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0C3XMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:32 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:36 2010
Message-Id: <20100330225835.531191958@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mart Raudsepp <mart.raudsepp@artecdesign.ee>,
       Antti Palosaari <crope@iki.fi>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [44/89] V4L/DVB: af9015: add new USB ID for KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mart Raudsepp <mart.raudsepp@artecdesign.ee>

commit c92f056308c4a77a833e1cc1e16c1b68974483a6 upstream.

Add new USB ID (1b80:e400) for KWorld PlusTV Dual DVB-T Stick (DVB-T 399U).
The model number on the devices sticker label is "KW-DVB-T 399UR".

Signed-off-by: Mart Raudsepp <mart.raudsepp@artecdesign.ee>
Acked-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/af9015.c      |    4 +++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1266,6 +1266,7 @@ static struct usb_device_id af9015_usb_t
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_MC810)},
 	{USB_DEVICE(USB_VID_KYE,       USB_PID_GENIUS_TVGO_DVB_T03)},
+/* 25 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_399U_2)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1346,7 +1347,8 @@ static struct dvb_usb_device_properties
 			{
 				.name = "KWorld PlusTV Dual DVB-T Stick " \
 					"(DVB-T 399U)",
-				.cold_ids = {&af9015_usb_table[4], NULL},
+				.cold_ids = {&af9015_usb_table[4],
+					     &af9015_usb_table[25], NULL},
 				.warm_ids = {NULL},
 			},
 			{
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -103,6 +103,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_KWORLD_399U				0xe399
+#define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
 #define USB_PID_KWORLD_395U_2				0xe39b
 #define USB_PID_KWORLD_395U_3				0xe395


