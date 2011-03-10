Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1CJKxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:53:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1CJKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=eYsBq8mczHkeRelI2+BJVKtI4RZHLDxxBLjGQjfW9Hu95X6SSERE1GGhdWy59AdgXZ
         +LFW1Dh9NucKn/ms5SWJCImzjZNQoB6mE9i8NymKifvBLFN7J6uQv3ISdrxmiawizyAn
         PTxNrXAsBadUHP+rffxIQbw4m2exXPiDCXzLw=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 16/21] staging: ft1000: Fix coding style in ft1000_open function.
Date: Thu, 10 Mar 2011 11:51:30 +0100
Message-Id: <1299754295-8493-17-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 6a9e5fa..b578630 100644
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

