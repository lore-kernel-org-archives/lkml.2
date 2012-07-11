Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab2GKPlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:41:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65223 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab2GKPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:41:09 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        marek.belisko@gmail.com
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: ft1000: Fix typo in ft1000_usb.c
Date: Thu, 12 Jul 2012 00:41:44 +0900
Message-Id: <1342021304-27728-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo within debug message of ft1000_usb.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 84c38d5..75381af 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -239,7 +239,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 			ft1000_destroy_dev(pft1000info->pFt1000Dev->net);
 			unregister_netdev(pft1000info->pFt1000Dev->net);
 			DEBUG
-			    ("ft1000_disconnect: network device unregisterd\n");
+			    ("ft1000_disconnect: network device unregistered\n");
 			free_netdev(pft1000info->pFt1000Dev->net);
 
 		}
-- 
1.7.11.1.104.ge7b44f1

