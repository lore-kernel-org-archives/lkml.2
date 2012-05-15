Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253Ab2EOCRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:49116 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883Ab2EOCQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 026/179] USB: moto_modem: Add USB identifier for the Motorola VE240.
Date: Mon, 14 May 2012 22:12:02 -0400
Message-ID: <1337048075-6132-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3938a0b32dc12229e76735679b37095bc2bc1578 upstream.

Tested on my phone, the ttyUSB device is created and is fully
functional.

Signed-off-by: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/moto_modem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/moto_modem.c b/drivers/usb/serial/moto_modem.c
index cf17183..0147042 100644
--- a/drivers/usb/serial/moto_modem.c
+++ b/drivers/usb/serial/moto_modem.c
@@ -25,6 +25,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
 	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
 	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
+	{ USB_DEVICE(0x22b8, 0x2c84) }, /* Motorola VE240 phone */
 	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
 	{ },
 };
-- 
1.7.9.6

