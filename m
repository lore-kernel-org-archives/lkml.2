Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671Ab2EOCbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:31:17 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53545 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475Ab2EOCSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 159/179] USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G
Date: Mon, 14 May 2012 22:14:15 -0400
Message-ID: <1337048075-6132-160-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijay Chavan <vijaychavan007@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e468561739fffb972d486b98f66c723936335136 upstream.

A new device ID pair is added for Qualcomm Modem present in Sagemcom's HiLo3G module.

Signed-off-by: Vijay Chavan <VijayChavan007@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 53a2d5a..225fc88 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -43,6 +43,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
-- 
1.7.9.6

