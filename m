Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3AHXle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:41:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:64285 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab3AHXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 58/77] USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.
Date: Tue, 8 Jan 2013 18:35:37 -0500
Message-ID: <1357688156-25387-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Hałasa <khalasa@piap.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6abff5dc4d5a2c90e597137ce8987e7fd439259b upstream.

Add USB IDs for Motorola H24 HSPA USB module.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index db34eb4..af45f73 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1545,6 +1545,16 @@ static const struct usb_device_id acm_ids[] = {
 	},
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
+	/* Motorola H24 HSPA module: */
+	{ USB_DEVICE(0x22b8, 0x2d91) }, /* modem                                */
+	{ USB_DEVICE(0x22b8, 0x2d92) }, /* modem           + diagnostics        */
+	{ USB_DEVICE(0x22b8, 0x2d93) }, /* modem + AT port                      */
+	{ USB_DEVICE(0x22b8, 0x2d95) }, /* modem + AT port + diagnostics        */
+	{ USB_DEVICE(0x22b8, 0x2d96) }, /* modem                         + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d97) }, /* modem           + diagnostics + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d99) }, /* modem + AT port               + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d9a) }, /* modem + AT port + diagnostics + NMEA */
+
 	{ USB_DEVICE(0x0572, 0x1329), /* Hummingbird huc56s (Conexant) */
 	.driver_info = NO_UNION_NORMAL, /* union descriptor misplaced on
 					   data interface instead of
-- 
1.7.12.1

