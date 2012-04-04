Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2DDScX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:32:23 -0400
Received: from forward6.mail.yandex.net ([77.88.60.125]:45154 "EHLO
	forward6.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab2DDScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:32:21 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 14:32:21 EDT
From: Anton Samokhvalov <pg83@yandex.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Johan Hovold <jhovold@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, Anton Samokhvalov <pg83@yandex.ru>
Subject: [PATCH 1/1] USB: sierra: add support for Sierra Wireless MC7710
Date: Wed,  4 Apr 2012 22:26:01 +0400
Message-Id: <1333563961-11200-1-git-send-email-pg83@yandex.ru>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just add new device id. 3G works fine, LTE not tested.

Signed-off-by: Anton Samokhvalov <pg83@yandex.ru>
---
 drivers/usb/serial/sierra.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index f14465a..fdd5aa2 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -289,6 +289,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 	{ USB_DEVICE(0x1199, 0x6859) },	/* Sierra Wireless AirCard 885 E */
 	{ USB_DEVICE(0x1199, 0x685A) },	/* Sierra Wireless AirCard 885 E */
+	{ USB_DEVICE(0x1199, 0x68A2) }, /* Sierra Wireless MC7710 */
 	/* Sierra Wireless C885 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6880, 0xFF, 0xFF, 0xFF)},
 	/* Sierra Wireless C888, Air Card 501, USB 303, USB 304 */
-- 
1.7.7.6

