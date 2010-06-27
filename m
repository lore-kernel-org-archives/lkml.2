Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0F0VvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 17:51:25 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:56561 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401Ab0F0VvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 17:51:24 -0400
Date: Sun, 27 Jun 2010 23:44:52 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/Makefile: conditionally descend to wireless
Message-ID: <20100627234452.0f9d19f1@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't descend to wireless unless it is actually used.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 0a0512a..9715c95 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -275,7 +275,7 @@ obj-$(CONFIG_USB_USBNET)        += usb/
 obj-$(CONFIG_USB_ZD1201)        += usb/
 obj-$(CONFIG_USB_IPHETH)        += usb/
 
-obj-y += wireless/
+obj-$(CONFIG_WLAN) += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/
 obj-$(CONFIG_HAMRADIO) += hamradio/
 obj-$(CONFIG_IRDA) += irda/
-- 
1.7.1
