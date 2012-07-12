Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161895Ab2GLXmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:42:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607Ab2GLWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 048/187] staging: r8712u: Add new USB IDs
Date: Thu, 12 Jul 2012 15:33:24 -0700
Message-Id: <20120712191526.801212532@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Schmidt <gentoo.lubomir@googlemail.com>

commit 3026b0e942c65c65c8fc80d391d004228b52b916 upstream.

There are two new devices for this driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -102,6 +102,8 @@ static struct usb_device_id rtl871x_usb_
 	/* - */
 	{USB_DEVICE(0x20F4, 0x646B)},
 	{USB_DEVICE(0x083A, 0xC512)},
+	{USB_DEVICE(0x25D4, 0x4CA1)},
+	{USB_DEVICE(0x25D4, 0x4CAB)},
 
 /* RTL8191SU */
 	/* Realtek */


