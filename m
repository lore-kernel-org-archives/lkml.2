Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2HOUZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:25:24 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62895 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2HOTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Rigbert Hamisch <rigbert@gmx.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 064/165] USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"
Date: Wed, 15 Aug 2012 15:46:48 -0400
Message-ID: <1345060109-9187-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rigbert Hamisch <rigbert@gmx.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1bfac90d1b8e63a4d44158c3445d8fda3fb6d5eb upstream.

add device ID for "HP un2430 Mobile Broadband Module"

Signed-off-by: Rigbert Hamisch <rigbert@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 225fc88..7facae0 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -26,6 +26,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
 	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
 	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
-- 
1.7.12.rc2

