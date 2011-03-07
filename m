Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1CGIYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:24:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1CGIVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=F6IVTV7rr/qBfbTfbgyW/uO1t2+YUyc4BVDzlMDCUAFP2H25I7wZJI/ydXPPoqtKx+
         cLFLRAumQDWECk+WI3CQI75IfA83wIh2tGUdma4J6jmU77SVl37cNHg8bupEy/yzWFU+
         V97vs6Qom0MwFpbLrSu00Y7v9yaxYqImQYtUM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 11/21] staging: ft1000: Fix coding style in ft1000_usb_transmit_complete function.
Date: Mon,  7 Mar 2011 09:21:16 +0100
Message-Id: <1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 4c5f443..6e89336 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -902,14 +902,14 @@ static int ft1000_reset(struct net_device *dev)
 static void ft1000_usb_transmit_complete(struct urb *urb)
 {
 
-    struct ft1000_device *ft1000dev = urb->context;
+	struct ft1000_device *ft1000dev = urb->context;
 
     //DEBUG("ft1000_usb_transmit_complete entered\n");
 
-    if (urb->status)
-        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
+	if (urb->status)
+		DEBUG("%s: TX status %d\n", ft1000dev->net->name, urb->status);
 
-    netif_wake_queue(ft1000dev->net);
+	netif_wake_queue(ft1000dev->net);
 
     //DEBUG("Return from ft1000_usb_transmit_complete\n");
 }
-- 
1.7.1

