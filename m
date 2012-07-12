Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162529Ab2GLXDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:03:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52623 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162037Ab2GLXDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 03/68] media: smsusb: add autodetection support for USB ID 2040:f5a0
Date: Thu, 12 Jul 2012 16:01:37 -0700
Message-Id: <20120712175035.720543767@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

commit 3e1141e2ce5667301a74ca2ef396d9bd5e995f7f upstream.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/siano/smsusb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -543,6 +543,8 @@ static const struct usb_device_id smsusb
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0xc0a0),
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x2040, 0xf5a0),
+		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ } /* Terminating entry */
 	};
 


