Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1KORNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:13:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64837 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab1KORNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:13:04 -0500
From: Grant Grundler <grundler@chromium.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>,
        Grant Grundler <grundler@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 5/5] net-next:asix: V2 Update VERSION
Date: Tue, 15 Nov 2011 09:12:43 -0800
Message-Id: <1321377163-26308-5-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1321377163-26308-1-git-send-email-grundler@chromium.org>
References: <1321377163-26308-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@google.com>

Only update VERSION to reflect previous changes.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index f870ab9..e6fed4d 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -36,7 +36,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION "26-Sep-2011"
+#define DRIVER_VERSION "08-Nov-2011"
 #define DRIVER_NAME "asix"
 
 /* ASIX AX8817X based USB 2.0 Ethernet Devices */
-- 
1.7.3.1

