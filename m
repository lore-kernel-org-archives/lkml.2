Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1CGIWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:22:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1CGIWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rCI8i0LDNh6+YQ21foZdajMLptokmyC43mpMxe2+43egGsx0EScfrtDQcAwmzAf8vB
         AHu6akAQg0phZZOD/SL0YAVT5+8Byl2rj4puPyTOpOPLiDZjcuUVnSOEK9hw23QRSee6
         wvpKgCY9Fh5FRAw0rVvEcQRx4yJbsAY/DjMLE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 16/21] staging: ft1000: Fix coding style in ft1000_open function.
Date: Mon,  7 Mar 2011 09:21:21 +0100
Message-Id: <1299486086-7325-17-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 26981ed..0b2acec 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1238,27 +1238,26 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_open (struct net_device *dev)
+static int ft1000_open(struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-    struct timeval tv; //mbelian
+	struct timeval tv;	//mbelian
 	int ret;
 
-    DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
-    //DEBUG("ft1000_open: dev->addr=%x, dev->addr_len=%d\n", dev->addr, dev->addr_len);
+	DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
+	//DEBUG("ft1000_open: dev->addr=%x, dev->addr_len=%d\n", dev->addr, dev->addr_len);
 
-	pInfo->stats.rx_bytes = 0; //mbelian
-	pInfo->stats.tx_bytes = 0; //mbelian
-	pInfo->stats.rx_packets = 0; //mbelian
-	pInfo->stats.tx_packets = 0; //mbelian
+	pInfo->stats.rx_bytes = 0;	//mbelian
+	pInfo->stats.tx_bytes = 0;	//mbelian
+	pInfo->stats.rx_packets = 0;	//mbelian
+	pInfo->stats.tx_packets = 0;	//mbelian
 	do_gettimeofday(&tv);
-    pInfo->ConTm = tv.tv_sec;
-	pInfo->ProgConStat = 0; //mbelian
+	pInfo->ConTm = tv.tv_sec;
+	pInfo->ProgConStat = 0;	//mbelian
 
+	netif_start_queue(dev);
 
-    netif_start_queue(dev);
-
-    netif_carrier_on(dev); //mbelian
+	netif_carrier_on(dev);	//mbelian
 
 	ret = ft1000_submit_rx_urb(pInfo);
 
-- 
1.7.1

