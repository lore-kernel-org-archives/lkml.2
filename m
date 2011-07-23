Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1GWWmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 18:42:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab1GWWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 18:42:13 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix cdc-phonet build
Content-Disposition: inline
From: Chris Clayton <chris2553@googlemail.com>
Date: Sat, 23 Jul 2011 23:41:51 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107232341.51965.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdc-phonet does not presently build on linux-3.0 because there is no entry for it in 
drivers/net/Makefile. This patch adds that entry.

Signed-off-by: Chris Clayton <chris2553@googlemail.com>
---

--- linux-3.0/drivers/net/Makefile.orig 2011-07-23 22:07:45.000000000 +0100
+++ linux-3.0/drivers/net/Makefile      2011-07-23 22:10:33.000000000 +0100
@@ -283,6 +283,7 @@
 obj-$(CONFIG_USB_USBNET)        += usb/
 obj-$(CONFIG_USB_ZD1201)        += usb/
 obj-$(CONFIG_USB_IPHETH)        += usb/
+obj-$(CONFIG_USB_CDC_PHONET)   += usb/

 obj-$(CONFIG_WLAN) += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/
