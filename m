Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1KNXWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:22:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39652 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:22:54 -0500
From: Grant Grundler <grundler@chromium.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 1/5] net-next:asix: PHY_MODE_RTL8211CL should be 0xC
Date: Mon, 14 Nov 2011 15:21:57 -0800
Message-Id: <1321312921-7748-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use correct value for rtl phy support.
(rtl phy are in AX88178 devices like NWU220G and USB2-ET1000).

Signed-off-by: Allan Chou <allan@asix.com.tw>
Tested-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index e81e22e..873860d 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -163,7 +163,7 @@
 #define MARVELL_CTRL_TXDELAY	0x0002
 #define MARVELL_CTRL_RXDELAY	0x0080
 
-#define	PHY_MODE_RTL8211CL	0x0004
+#define	PHY_MODE_RTL8211CL	0x000C
 
 /* This structure cannot exceed sizeof(unsigned long [5]) AKA 20 bytes */
 struct asix_data {
-- 
1.7.3.1

