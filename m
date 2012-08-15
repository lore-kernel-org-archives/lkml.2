Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2HOTvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:36975 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2HOTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Florian Echtler <floe@butterbrot.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 106/165] USB: Serial: Add device ID for Sierra Wireless MC8305
Date: Wed, 15 Aug 2012 15:47:30 -0400
Message-ID: <1345060109-9187-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Echtler <floe@butterbrot.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2f1def2695c223b2aa325e5e47d0d64200a45d23 upstream.

A new device ID pair is added for Sierra Wireless MC8305.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 7facae0..6869b52 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -76,6 +76,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x1199, 0x9008)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{USB_DEVICE(0x1199, 0x9009)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{USB_DEVICE(0x1199, 0x900a)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
+	{USB_DEVICE(0x1199, 0x9011)},   /* Sierra Wireless Gobi 2000 Modem device (MC8305) */
 	{USB_DEVICE(0x16d8, 0x8001)},	/* CMDTech Gobi 2000 QDL device (VU922) */
 	{USB_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{ }				/* Terminating entry */
-- 
1.7.12.rc2

