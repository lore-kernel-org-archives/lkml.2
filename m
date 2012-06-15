Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2FOUMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:12:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45704 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab2FOUMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:12:50 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Lubomir Schmidt <gentoo.lubomir@googlemail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] staging: r8712u: Add new USB IDs
Date: Fri, 15 Jun 2012 15:12:17 -0500
Message-Id: <1339791137-18986-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.130.g36e6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lubomir Schmidt <gentoo.lubomir@googlemail.com>

There are two new devices for this driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 9bd18e2..69f616c 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -102,6 +102,8 @@ static struct usb_device_id rtl871x_usb_id_tbl[] = {
 	/* - */
 	{USB_DEVICE(0x20F4, 0x646B)},
 	{USB_DEVICE(0x083A, 0xC512)},
+	{USB_DEVICE(0x25D4, 0x4CA1)},
+	{USB_DEVICE(0x25D4, 0x4CAB)},
 
 /* RTL8191SU */
 	/* Realtek */
-- 
1.7.10.130.g36e6c

