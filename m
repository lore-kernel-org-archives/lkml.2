Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab0GBHBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:01:06 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:39335 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924Ab0GBHBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:01:04 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ajb@spheresystems.co.uk
Subject: [PATCH] Add new pair of PIDs to qcserial gobi driver
Date: Fri,  2 Jul 2010 08:01:00 +0100
Message-Id: <1278054060-25591-1-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.6.2.5
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the Generic Qualcomm Gobi 2000 WWAN UMTS/CDMA modem

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/usb/serial/qcserial.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 93d72eb..cde67ca 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -51,6 +51,8 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8185)},	/* Dell Gobi 2000 QDL device (N0218, VU936) */
 	{USB_DEVICE(0x413c, 0x8186)},	/* Dell Gobi 2000 Modem device (N0218, VU936) */
+	{USB_DEVICE(0x05c6, 0x9208)},	/* Generic Gobi 2000 QDL device */
+	{USB_DEVICE(0x05c6, 0x920b)},	/* Generic Gobi 2000 Modem device */
 	{USB_DEVICE(0x05c6, 0x9224)},	/* Sony Gobi 2000 QDL device (N0279, VU730) */
 	{USB_DEVICE(0x05c6, 0x9225)},	/* Sony Gobi 2000 Modem device (N0279, VU730) */
 	{USB_DEVICE(0x05c6, 0x9244)},	/* Samsung Gobi 2000 QDL device (VL176) */
-- 
1.6.2.5

