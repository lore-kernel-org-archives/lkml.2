Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0GAUtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:49:35 -0400
Received: from kroah.org ([198.145.64.141]:47145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab0GAUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:32 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.058326739@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nobhiro KUSUNO <n-kusuno@fc4.so-net.ne.jp>
Subject: [patch 014/164] Staging: rt2870: add device ID of MelCo.,Inc. WLI-UC-G301N
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro KUSUNO <n-kusuno@fc4.so-net.ne.jp>

commit de37cd49b5a54facef174cf34496919857436e8f upstream.

My wireless LAN module 'MelCo.,Inc. WLI-UC-G301N' works fine,
if the following line is added into 2870_main_dev.c.

Signed-off-by: Nobhiro KUSUNO <n-kusuno@fc4.so-net.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -97,6 +97,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x5A57, 0x0282)},	/* Zinwell */
 	{USB_DEVICE(0x7392, 0x7718)},
 	{USB_DEVICE(0x7392, 0x7717)},
+	{USB_DEVICE(0x0411, 0x016f)},	/* MelCo.,Inc. WLI-UC-G301N */
 	{USB_DEVICE(0x1737, 0x0070)},	/* Linksys WUSB100 */
 	{USB_DEVICE(0x1737, 0x0071)},	/* Linksys WUSB600N */
 	{USB_DEVICE(0x0411, 0x00e8)},	/* Buffalo WLI-UC-G300N */


