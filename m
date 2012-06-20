Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2FTSXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:23:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2FTSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:19 -0400
Message-Id: <20120620173024.278710472@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>
Subject: [ 39/61] USB: serial: cp210x: add Optris MS Pro usb id
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>

commit 5bbfa6f427c1d7244a5ee154ab8fa37265a5e049 upstream.

Signed-off-by: Mikko Tuumanen <mikko.tuumanen@qemsoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -82,6 +82,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
 	{ USB_DEVICE(0x10C4, 0x806F) }, /* IMS USB to RS422 Converter Cable */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
+	{ USB_DEVICE(0x10C4, 0x80C4) }, /* Cygnal Integrated Products, Inc., Optris infrared thermometer */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
 	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
 	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */


