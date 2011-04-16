Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1DPTAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:00:23 -0400
Received: from elizabethmyers.me.uk ([204.152.223.223]:38402 "EHLO
	sporksirc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1DPTAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:00:19 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Apr 2011 15:00:19 EDT
From: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
Subject: [PATCH 1/1] moto_modem: Add USB identifier for the Motorola VE240.
Date: Sat, 16 Apr 2011 14:49:51 -0400
Message-Id: <1302979791-25419-1-git-send-email-elizabeth@sporksirc.net>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on my phone, the ttyUSB device is created and is fully
functional.

Signed-off-by: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
---
 drivers/usb/serial/moto_modem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/moto_modem.c b/drivers/usb/serial/moto_modem.c
index 653465f..e2bfecc 100644
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
1.7.4.4

