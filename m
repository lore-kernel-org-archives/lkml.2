Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0JWSWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:22:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45630 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab0JWSWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WDfNU+X++8M0mr9CXLla/7Qmq4TcJR08dyJ4MuZlVer1yBRPdxcadNLaX01aBCFWpC
         GhaTykmNhfmWh422ZfiJMC1pQT4d3bhkelJ2mbct0NSJXBouYP0Uq7YPWMjVn39hm4UV
         9YiKKJOALEBKd6aaiIVkuEljbbjHHFNbO96+w=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Neil Munro <neilmunro@gmail.com>
Subject: [PATCH] Staging: RT2860: Fixed two errors in usb_main_dev.c
Date: Sat, 23 Oct 2010 19:25:13 +0100
Message-Id: <1287858313-22645-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_main_dev.c has now been cleaned of all errors, just needed spaces around colon symbols.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/usb_main_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index ebf9074..30c16dd 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -368,8 +368,8 @@ struct usb_driver rtusb_driver = {
 	.id_table = rtusb_usb_id,

 #ifdef CONFIG_PM
-suspend:rt2870_suspend,
-resume:rt2870_resume,
+suspend : rt2870_suspend,
+resume : rt2870_resume,
 #endif
 };

--
1.7.3.2

