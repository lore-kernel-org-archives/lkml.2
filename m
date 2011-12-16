Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab1LPTvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:51:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785Ab1LPTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:02 2011
Message-Id: <20111216194601.932979401@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [48/53] staging: r8712u: Add new USB ID
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit c7caf4d4c56aee40b995f5858ccf1c814f3d2da2 upstream.

Add USB ID for Sitecom WLA-2000 v1.001 WLAN.

Reported-and-tested-by: Roland Gruber <post@rolandgruber.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8712/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -86,6 +86,7 @@ static struct usb_device_id rtl871x_usb_
 	{USB_DEVICE(0x0DF6, 0x0045)},
 	{USB_DEVICE(0x0DF6, 0x0059)}, /* 11n mode disable */
 	{USB_DEVICE(0x0DF6, 0x004B)},
+	{USB_DEVICE(0x0DF6, 0x005D)},
 	{USB_DEVICE(0x0DF6, 0x0063)},
 	/* Sweex */
 	{USB_DEVICE(0x177F, 0x0154)},


