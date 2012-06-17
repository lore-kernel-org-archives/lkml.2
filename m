Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2FQSf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:35:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50223 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758115Ab2FQSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:40 -0400
Message-Id: <20120617175948.463936417@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 50/69] USB: serial: cp210x: add Optris MS Pro usb id
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>

commit 5bbfa6f427c1d7244a5ee154ab8fa37265a5e049 upstream.

Signed-off-by: Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 1b19262..73d25cd 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -82,6 +82,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
 	{ USB_DEVICE(0x10C4, 0x806F) }, /* IMS USB to RS422 Converter Cable */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
+	{ USB_DEVICE(0x10C4, 0x80C4) }, /* Cygnal Integrated Products, Inc., Optris infrared thermometer */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
 	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
 	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */


