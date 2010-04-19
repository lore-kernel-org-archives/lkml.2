Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0DSUPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:15:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0DSUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SM/3LqpQ7mhQOcrFCL4As8haPFfB/neBqer+liReUMo18w9M/Pp0K7C6dZvLkSbekn
         dfY1GQ2ybd7OEBvMbJW/7ffq6tr6pPuPwMRO+2dfI1wTso5gX7qWTr6jQF9x5SAXJLVu
         BQYBDVZkuy8KkE3vJFqLrKk33S3XRrKMch91k=
From: Trey <lewis.r.evans@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Trey <lewis.r.evans@gmail.com>
Subject: [PATCH] Staging: rt2860: fix usb_main_dev.c style errors
Date: Mon, 19 Apr 2010 16:15:37 -0400
Message-Id: <1271708137-10957-1-git-send-email-lewis.r.evans@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <Style Patch>
References: <Style Patch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct several style errors related to pointers in usb_main_dev.c.

Signed-off-by: Trey Evans <lewis.r.evans@gmail.com>
---
 drivers/staging/rt2860/usb_main_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index 1873a79..abe9f24 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -153,7 +153,7 @@ static void rt2870_disconnect(struct usb_device *dev, struct rt_rtmp_adapter *pA
 static int __devinit rt2870_probe(IN struct usb_interface *intf,
 				  IN struct usb_device *usb_dev,
 				  IN const struct usb_device_id *dev_id,
-				  struct rt_rtmp_adapter ** ppAd);
+				  struct rt_rtmp_adapter **ppAd);
 
 #ifndef PF_NOFREEZE
 #define PF_NOFREEZE  0
@@ -801,7 +801,7 @@ static void rt2870_disconnect(struct usb_device *dev, struct rt_rtmp_adapter *pA
 static int __devinit rt2870_probe(IN struct usb_interface *intf,
 				  IN struct usb_device *usb_dev,
 				  IN const struct usb_device_id *dev_id,
-				  struct rt_rtmp_adapter ** ppAd)
+				  struct rt_rtmp_adapter **ppAd)
 {
 	struct net_device *net_dev = NULL;
 	struct rt_rtmp_adapter *pAd = (struct rt_rtmp_adapter *)NULL;
-- 
1.6.3.3

