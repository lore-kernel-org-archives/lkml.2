Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab1DNSDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:03:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:42351 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965063Ab1DNR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eduardo Costa <ecosta.tmp@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 189/209] p54usb: New USB ID for Gemtek WUBI-100GW
Date: Thu, 14 Apr 2011 13:55:47 -0400
Message-Id: <1302803767-9715-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Costa <ecosta.tmp@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 56e6417b49132d4f56e9f2241d31942b90b46315 upstream.

This USB ID is for the WUBI-100GW 802.11g Wireless LAN USB Device that
uses p54usb.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Eduardo Costa <ecosta.tmp@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 960a517..906fd6c 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
 	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
+	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
 	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
-- 
1.7.4.4

