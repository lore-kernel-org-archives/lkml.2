Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2GAS1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:27:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884Ab2GASQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:26 -0400
Message-Id: <20120701172007.416553655@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lubomir Schmidt <gentoo.lubomir@googlemail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 05/48] staging: r8712u: Add new USB IDs
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Schmidt <gentoo.lubomir@googlemail.com>

commit 3026b0e942c65c65c8fc80d391d004228b52b916 upstream.

There are two new devices for this driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


