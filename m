Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0GAWUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:20:20 -0400
Received: from kroah.org ([198.145.64.141]:47194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab0GAUti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.724860147@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>,
       =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 022/164] V4L/DVB: gspca - stv06xx: Remove the 046d:08da from the stv06xx driver
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Andrén <erik.andren@gmail.com>

commit 55e0b489a39bb635a44f769d620e44c70d9c065b upstream.

The 046d:08da usb id shouldn't be associated with the stv06xx driver as they're
not compatible with each other.
This fixes a bug where Quickcam Messenger cams fail to use its proper driver
(gspca-zc3xx), rendering the camera inoperable.

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
Tested-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/stv06xx/stv06xx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -496,8 +496,6 @@ static const __devinitdata struct usb_de
 	{USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },
 	/* QuickCam Messenger (new) */
 	{USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },
-	/* QuickCam Messenger (new) */
-	{USB_DEVICE(0x046D, 0x08DA), .driver_info = BRIDGE_ST6422 },
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);


