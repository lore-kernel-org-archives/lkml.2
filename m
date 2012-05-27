Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2E0Bj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:39:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965358Ab2E0BLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:52 -0400
Message-Id: <20120527010434.197473464@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 74/94] [media] smsusb: add autodetection support for USB ID 2040:c0a0
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

commit 4d1b58b84472d1d300a66e1c5fd765b21e74ba15 upstream.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/siano/smsusb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -542,6 +542,8 @@ static const struct usb_device_id smsusb
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0xc090),
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xc0a0),
+		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ } /* Terminating entry */
 	};
 


