Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab2BJWti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:49:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab2BJWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:18 -0500
MIME-Version: 1.0
Message-Id: <20120210223444.395055875@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 47/55] staging: r8712u: Add new Sitecom UsB ID
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 1793bf1deddc8ce25dc41925d5dbe64536c841b6 upstream.

Add USB ID for SITECOM WLA-1000 V1 001 WLAN

Reported-and-tested-by: Roland Gruber <post@rolandgruber.de>
Reported-and-tested-by: Dario Lucia <dario.lucia@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -86,6 +86,7 @@ static struct usb_device_id rtl871x_usb_
 	{USB_DEVICE(0x0DF6, 0x0045)},
 	{USB_DEVICE(0x0DF6, 0x0059)}, /* 11n mode disable */
 	{USB_DEVICE(0x0DF6, 0x004B)},
+	{USB_DEVICE(0x0DF6, 0x005B)},
 	{USB_DEVICE(0x0DF6, 0x005D)},
 	{USB_DEVICE(0x0DF6, 0x0063)},
 	/* Sweex */


