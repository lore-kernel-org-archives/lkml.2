Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1HHVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:12:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43400 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1HHVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:12:03 -0400
From: Vijay Chavan <vijaychavan007@gmail.com>
To: gregkh@suse.de
Cc: shardy@redhat.com, mge@arcor.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vijay Chavan <VijayChavan007@gmail.com>
Subject: [PATCH] USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G
Date: Tue,  9 Aug 2011 02:41:12 +0530
Message-Id: <1312837872-2159-1-git-send-email-VijayChavan007@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new device ID pair is added for Qualcomm Modem present in Sagemcom's HiLo3G module.

Signed-off-by: Vijay Chavan <VijayChavan007@gmail.com>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 54a9dab..27f9ae4 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -45,6 +45,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
 	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
-- 
1.7.1

