Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1HAX1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:27:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1HAX11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.001134097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yoann DI-RUZZA <y.diruzza@lim.eu>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [34/70] rtlwifi: rtl8192cu: Add new USB ID for Netgear WNA1000M
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yoann DI-RUZZA <y.diruzza@lim.eu>

commit 35cbcbc6f39da30c39bc0a1e679ec44506c4eb3d upstream.

Signed-off-by: Yoann DI-RUZZA <y.diruzza@lim.eu>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -278,6 +278,7 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
+	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
 	{RTL_USB_DEVICE(0x0Df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	/* HP - Lite-On ,8188CUS Slim Combo */


