Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1HNQIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1HNQIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:56 2011
Message-Id: <20110812210556.828737046@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-net@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Clayton <chris2553@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [54/90] Fix cdc-phonet build
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Chris Clayton <chris2553@googlemail.com>

[ Upstream commit a0295a3b6775ab88f5883684e14bbda8d287822d ]

Try to send to correct address this time!

----------  Forwarded Message  ----------

Subject: [54/90] [PATCH] Fix cdc-phonet build
Date: Saturday 23 Jul 2011
From: Chris Clayton <chris2553@googlemail.com>
To: linux-net@vger.kernel.org

cdc-phonet does not presently build on linux-3.0 because there is no entry for it in
drivers/net/Makefile. This patch adds that entry.

Signed-off-by: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -283,6 +283,7 @@ obj-$(CONFIG_USB_HSO)		+= usb/
 obj-$(CONFIG_USB_USBNET)        += usb/
 obj-$(CONFIG_USB_ZD1201)        += usb/
 obj-$(CONFIG_USB_IPHETH)        += usb/
+obj-$(CONFIG_USB_CDC_PHONET)   += usb/
 
 obj-$(CONFIG_WLAN) += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/


