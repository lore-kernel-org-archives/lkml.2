Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1HBUaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:30:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50765 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754944Ab1HBUaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:30:11 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18xW8FJb5YxZw6oqvmMNl8yPbFKCAWcQB6sYYoAIb
	BHptzwtWqLQn75
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless adapter
Date: Tue, 2 Aug 2011 22:29:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-0.slh.5-aptosid-686; KDE/4.6.5; i686; ; )
Cc: linux-wireless@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108022229.58532.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: stable <stable@kernel.org> [2.6.39+]
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    3 +++
 1 files changed, 5 insertions(+), 0 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -322,6 +322,9 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
 	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
+
+	/****** 8192CUS Dongle ********/
+	{RTL_USB_DEVICE(0x050D, 0x2103, rtl92cu_hal_cfg)}, //Belkin - Edimax
 	{}
 };
 
