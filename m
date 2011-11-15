Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1KOAwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:52:46 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51770 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1KOAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:52:44 -0500
From: Grant Grundler <grundler@chromium.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 5/5] net-next:asix: v2 update VERSION only
Date: Mon, 14 Nov 2011 16:52:37 -0800
Message-Id: <1321318357-17723-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update VERSION to reflect previous changes.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -36,7 +36,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION "26-Sep-2011"
+#define DRIVER_VERSION "08-Nov-2011"
 #define DRIVER_NAME "asix"
 
 /* ASIX AX8817X based USB 2.0 Ethernet Devices */
